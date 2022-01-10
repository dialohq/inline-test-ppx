open Ppxlib
module P = Ppxlib.Parsetree

let nothing loc =
  Ppxlib.Ast_helper.Exp.construct { txt = Lident "()"; loc } None

(* let test_attribute = let open Ppxlib.Attribute in declare "dialo.inline_test"
   Ppxlib.Attribute.Context.pstr_eval Ast_pattern.__ (fun _ -> ()) *)

let map_struct_item ~found_test struct_item =
  { struct_item with
    pstr_desc =
      (match struct_item.P.pstr_desc with
      | Pstr_eval (expr, l) ->
        if List.exists ~f:(fun attr -> attr.attr_name.txt = "inline_test") l
        then
          match Sys.getenv_opt "INLINE_TEST" with
          | Some ("1" | "true") ->
            let () = found_test () in
            let loc = expr.pexp_loc in
            Pstr_eval
              ( [%expr
                  match [%external process] with
                  | Some process ->
                    (match Js.Dict.get process#env "NODE_ENV" with
                    | Some "test" ->
                      [%e expr]
                    | _ ->
                      ())
                  | None ->
                    ()]
              , [] )
          | Some _ | None ->
            Pstr_eval (nothing struct_item.P.pstr_loc, l)
        else
          struct_item.pstr_desc
      | x ->
        x)
  }

(* match Ppxlib.Attribute.consume test_attribute struct_item with | None ->
   struct_item | Some (struct_item, ()) -> { struct_item with pstr_desc = } *)

let ast_mapper found_test =
  object
    inherit Ppxlib.Ast_traverse.map as super

    method! structure_item struct_item =
      map_struct_item ~found_test (super#structure_item struct_item)
  end

let on_test_found s =
  let project_root = Bs_config.find_project_root () in
  let config = Bs_config.get_bs_config project_root in
  let filename = Ppxlib.File_path.get_default_path_str s in
  File_generation.make ~config ~project_root filename

let impl s =
  let test_found = ref false in
  let found_test () = test_found := true in
  let res = (ast_mapper found_test)#structure s in
  let () = if !test_found then on_test_found s in
  res

let () = Ppxlib.Driver.register_transformation "dialo.inline_test" ~impl
