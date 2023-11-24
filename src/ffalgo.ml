open Graph
open Tools

(* Return a path from s to t with the maximal minimal capacity. *)
let find_path g s t =
  let table = Hashtbl.create (nb_nodes g) in
  (* Some bordel TODO *)
