open Graph

val find_path: int graph -> id -> id -> id list option
val compute_flow: int graph -> id list -> int
val next_graph: int graph -> id list -> int -> int graph