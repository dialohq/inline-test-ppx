open Bs_config

let _res_output_folder module_type =
  let folder_name =
    match module_type with
    | ES6 ->
      "es6"
    | ES6_global ->
      "es6_global"
    | CommonJs ->
      "js"
  in
  "lib/" ^ folder_name

let make ~config ~project_root:_ filename =
  let last_dot_pos = String.rindex filename '.' in
  let output_path = String.sub filename ~pos:0 ~len:last_dot_pos in
  let oc = open_out (output_path ^ ".test" ^ config.suffix) in
  let last_slash_pos = String.rindex filename '/' in
  let module_name =
    String.sub
      filename
      ~pos:(last_slash_pos + 1)
      ~len:(last_dot_pos - last_slash_pos - 1)
  in
  match config.module_type with
  | ES6 | ES6_global ->
    Printf.fprintf oc {|import "./%s%s";|} module_name config.suffix
  | CommonJs ->
    Printf.fprintf oc {|require("./%s%s");|} module_name config.suffix;
    close_out oc
