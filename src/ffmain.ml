open Gfile
open Tools
open Ffalgo


let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 5 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile source sink outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing a graph\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n" ^
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n");
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)

  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(2)
  and source = int_of_string Sys.argv.(3)
  and sink = int_of_string Sys.argv.(4)

  in

  (* Open output file. *)
  let outfile_channel = open_out outfile in

  (* Read the graph in infile *)
  let graph = from_file infile in

  (* Cast string file read to int graph *)
  let graph = gmap graph int_of_string in
  
  (* Run Ford-Fulkerson algorithm on the graph. *)
  let final_graph = ford_fulkerson graph source sink in 
  let str_graph = gmap final_graph (fun (x,y) -> Printf.sprintf "%d/%d" x y) in
  
  (* Write the final graph to outfile. *)
  let () = Printf.fprintf outfile_channel "%s\n" (digraph str_graph) in
  ()
  
  

