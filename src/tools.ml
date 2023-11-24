open Graph

(* Clones a graph, and deletes all his arcs. *)
let clone_nodes g = n_fold g new_node empty_graph

(* Maps all arcs of g by f. *)
let gmap g f = e_fold g (fun acu e -> new_arc acu (f e)) (clone_nodes g)

(* Adds n to the value of the arc between id1 and id2. 
* If the arc doesn't exist, create one. *)
let add_arc g id1 id2 n = 
  if find_arc id1 id2 = None 
    then new_arc g {src = id1; tgt = id2; lbl = n}
    else 
      let f e = match (e.src, e.tgt) with
        | (id1, id2) -> {e with lbl = e.lbl+n}
        | _ -> e
      in gmap g f

