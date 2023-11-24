open Graph

(* Return the number of nodes of a graph. *)
let nb_nodes g = n_fold g (fun r n -> r + 1) 0

(* Clones a graph, and deletes all his arcs. *)
let clone_nodes g = n_fold g new_node empty_graph

(* Maps all arcs of g by f. *)
let gmap g f = e_fold g (fun acu e -> new_arc acu {e with lbl = f e.lbl}) (clone_nodes g)

(* Adds n to the value of the arc between id1 and id2. 
* If the arc doesn't exist, create one. *)
let add_arc g id1 id2 n = 
   if Option.is_none (find_arc g id1 id2)
    then new_arc g {src = id1; tgt = id2; lbl = n}
    else 
      let f e = 
        let i = if (e.src,e.tgt) = (id1,id2) then n else 0 in
          {e with lbl = e.lbl + i}
      in gmap g f
      (* Pas faisable avec gmap car gmap ne prend pas les arcs mais les labels *)

