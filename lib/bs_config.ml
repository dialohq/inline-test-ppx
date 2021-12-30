let bsconfig_filename = "bsconfig.json"

type module_type =
  | ES6
  | ES6_global
  | CommonJs

type config =
  { module_type : module_type
  ; in_source : bool
  ; suffix : string
  }

let default_config =
  { module_type = CommonJs; in_source = false; suffix = ".bs.js" }

let rec find_project_root ~dir =
  if Sys.file_exists (Filename.concat dir bsconfig_filename) then
    dir
  else
    let parent = dir |> Filename.dirname in
    if parent = dir then (
      prerr_endline
        ("Error: cannot find project root containing " ^ bsconfig_filename ^ ".");
      assert false)
    else
      find_project_root ~dir:parent

let find_project_root () = find_project_root ~dir:(Sys.getcwd ())

let get_bs_config_file project_root =
  let bsconfig = Filename.concat project_root "bsconfig.json" in
  match bsconfig |> Sys.file_exists with true -> Some bsconfig | false -> None

let parse_package_specs ~config =
  List.fold_left ~init:config ~f:(fun config -> function
    | "module", `String ("es6" | "es7-global") ->
      { config with module_type = ES6 }
    | "module", `String "commonjs" ->
      { config with module_type = CommonJs }
    | "in-source", `Bool in_source ->
      { config with in_source }
    | _ ->
      config)

let parse_bs_config =
  List.fold_left ~init:default_config ~f:(fun config -> function
    | "suffix", `String suffix ->
      { config with suffix }
    | "package-specs", (`Assoc package_specs | `List (`Assoc package_specs :: _))
      ->
      parse_package_specs ~config package_specs
    | _ ->
      config)

let get_bs_config project_root =
  match get_bs_config_file project_root with
  | None ->
    failwith "could not find bsconfig.json"
  | Some file ->
    let json = Yojson.Safe.from_file file in
    (match json with
    | `Assoc bs_config ->
      parse_bs_config bs_config
    | _ ->
      failwith (file ^ "should be an object"))
