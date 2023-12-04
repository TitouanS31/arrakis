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
         "    🟄  source  : identifier of the source vertex (used by the ford-fulkerson algorithm)\n" ^
         "    🟄  sink    : identifier of the sink vertex (ditto)\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) source-id(2) sink-id(3) outfile(4) *)
  
  let infile = Sys.argv.(1)
  and outfile = Sys.argv.(4)
  
  (* These command-line arguments are not used for the moment. *)
  and _source = int_of_string Sys.argv.(2)
  and _sink = int_of_string Sys.argv.(3)
  in

  (* Open file *)
  let graph = from_file infile in

  (* Rewrite the graph that has been read. *)
  let () = write_file outfile graph in

  let graph = gmap graph int_of_string in

  let opath = find_path graph 0 5 in
  let path = Option.get opath in
  let flow = compute_flow graph path in
  let ng = next_graph graph path flow in

  (* List.iter (Printf.printf "%d ") path;
  Printf.printf "\nFlow: %d\n" flow;
  export (gmap ng string_of_int); *)

  let onpath = find_path ng 0 5 in
  let npath = Option.get onpath in
  let nflow = compute_flow ng npath in
  let nng = next_graph ng npath nflow in

  List.iter (Printf.printf "%d ") npath;
  Printf.printf "\nFlow: %d\n" nflow;
  export (gmap nng string_of_int);

  (* export (gmap nng string_of_int); *)

  let fg = ford_fulkerson graph 0 5 in 
  export (gmap fg (fun (x,y) -> Printf.sprintf "(%d,%d)" x y));

  (* TODO: test compute_flow, next_graph and finish that dumb *)
