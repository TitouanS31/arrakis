open Gfile
open Tools
(*open Ffalgo*)
open Cricket


let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  (*and outfile = Sys.argv.(4)*)
  
  (* These command-line arguments are not used for the moment. *)
  (*and source = int_of_string Sys.argv.(2)
  and sink = int_of_string Sys.argv.(3)*)
  in

(*
  (* Open file *)
  let graph = from_file infile in

  
  let graph = gmap graph int_of_string in
  
  let final_graph = ford_fulkerson graph source sink in 
  let str_graph = gmap final_graph (fun (x,y) -> Printf.sprintf "(%d,%d)" x y) in
  
  (* Rewrite the graph that has been read. *)
  let () = write_file outfile str_graph in
  ()
  
  *)

  let result = analyze_cricket infile in
  
  let show (name,can_win,graph) = 
    let () = Printf.printf "%s " name in
    let () = if can_win 
      then Printf.printf "can win.\n"
      else Printf.printf "can't win anymore.\n"
    in
    let str_graph = gmap graph (fun (x,y) -> Printf.sprintf "(%d,%d)" x y) in
    let () = export str_graph in
    let () = Printf.printf "\n\n-------------------------\n\n" in
    ()
  in
  List.iter show result

