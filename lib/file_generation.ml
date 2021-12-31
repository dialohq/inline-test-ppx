open Bs_config

(* todo use Filename helpers to make it platform agnostic *)

let res_output_folder ~in_source module_type =
  match in_source with
  | true ->
    "../../"
  | false ->
    let prefix = "../" in
    let folder_name =
      match module_type with
      | ES6 ->
        "es6"
      | ES6_global ->
        "es6_global"
      | CommonJs ->
        "js"
    in
    prefix ^ folder_name ^ "/"

let remove_project_root_and_ext ~project_root path =
  let last_dot_pos = String.rindex path '.' in
  let start_pos = String.length project_root in
  String.sub path ~pos:(start_pos + 1) ~len:(last_dot_pos - start_pos - 1)

let%expect_test "remove_project_root_and_ext" =
  let path = {|/Users/paul/code/inline-test-ppx/project_sample/src/Demo.res|} in
  let project_root = {|/Users/paul/code/inline-test-ppx/project_sample|} in
  remove_project_root_and_ext ~project_root path |> print_string;
  [%expect "src/Demo"]

let make_paths ~in_source ~suffix ~module_type ~project_root filename =
  let last_dot_pos = String.rindex filename '.' in
  let last_slash_pos = String.rindex filename '/' in
  let module_name =
    String.sub
      filename
      ~pos:(last_slash_pos + 1)
      ~len:(last_dot_pos - last_slash_pos - 1)
  in
  let extension =
    match module_type with ES6 | ES6_global -> ".mjs" | CommonJs -> ".cjs"
  in
  let output_path = "__inline_test." ^ module_name ^ extension in
  let import_path = remove_project_root_and_ext ~project_root filename in
  let import_path =
    res_output_folder ~in_source module_type ^ import_path ^ suffix
  in
  output_path, import_path

let%expect_test "make_paths" =
  let path = {|/Users/paul/code/inline-test-ppx/project_sample/src/Demo.res|} in
  let project_root = {|/Users/paul/code/inline-test-ppx/project_sample|} in
  let output_path, import_path =
    make_paths
      ~in_source:true
      ~suffix:".mjs"
      ~module_type:ES6
      ~project_root
      path
  in
  print_string output_path;
  [%expect "__inline_test.Demo.mjs"];
  print_string import_path;
  [%expect "../../src/Demo.mjs"]

let make_path_and_content ~module_type ~in_source ~project_root ~suffix filename
  =
  let output_path, import_path =
    make_paths ~in_source ~suffix ~module_type ~project_root filename
  in
  let content =
    match module_type with
    | CommonJs ->
      Printf.sprintf
        {|
try {
  require("%s");
} catch (e) { 
  if (e.code !== "MODULE_NOT_FOUND") throw e;
}|}
        import_path
    | ES6 | ES6_global ->
      Printf.sprintf
        {|
import("%s").catch(e => {
  if (e.code !== "ERR_MODULE_NOT_FOUND") reject(e)
});|}
        import_path
  in
  output_path, content

let make ~config:{ module_type; in_source; suffix } ~project_root filename =
  let output_path, content =
    make_path_and_content ~module_type ~in_source ~project_root ~suffix filename
  in
  let oc = open_out output_path in
  output_string oc content;
  close_out oc
