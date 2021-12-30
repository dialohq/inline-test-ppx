type module_type =
  | ES6
  | ES6_global
  | CommonJs

type config =
  { module_type : module_type
  ; in_source : bool
  ; suffix : string
  }

val find_project_root : unit -> string

val get_bs_config : string -> config
