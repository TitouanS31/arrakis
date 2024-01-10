open Gfile
open Tools
open Cricket


let () =

  (* Check the number of command-line arguments *)
  if Array.length Sys.argv <> 3 then
    begin
      Printf.printf
        "\n ✻  Usage: %s infile outfile\n\n%s%!" Sys.argv.(0)
        ("    🟄  infile  : input file containing competition statistics\n" ^
         "    🟄  outfile : output file in which the result should be written.\n\n") ;
      exit 0
    end ;


  (* Arguments are : infile(1) outfile(2) *)
  let infile = Sys.argv.(1) in
  let outfile = Sys.argv.(2) in

  (* Analyze statistics stored in infile *)
  let result = analyze_cricket infile in

  let outfile_channel = open_out outfile in
  
  let write_block (name,can_win,graph) = 
    let () = Printf.fprintf outfile_channel "%s " name in
    let () = if can_win 
      then Printf.fprintf outfile_channel "can win.\n\n"
      else Printf.fprintf outfile_channel "can't win anymore.\n\n"
    in

    (* Convert to string graph. *)
    let str_graph = gmap graph 
      (fun (x,y) -> 
        if y < Int.max_int / 2 
        then Printf.sprintf "%d/%d" x y 
        else "&infin;") (* Infinity symbol for big numbers. *)
    in

    (* Write digraph. *)
    let () = Printf.fprintf outfile_channel "%s" (digraph str_graph) in

    (* Write separating line. *)
    let () = Printf.fprintf outfile_channel "\n\n-------------------------\n\n" in
    ()

  in

  (* Write all blocks. *)
  let () = List.iter write_block result in
  
  let () = close_out outfile_channel in
  ()

