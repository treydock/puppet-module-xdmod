type Xdmod::Resource_Spec = Struct[{
  resource => String,
  start_date => Optional[String],
  end_date => Optional[String],
  processors => Integer,
  nodes => Integer,
  ppn => Integer,
  cpu_node_count => Optional[Integer],
  cpu_processor_count => Optional[Integer],
  cpu_ppn => Optional[Integer],
  gpu_node_count => Optional[Integer],
  gpu_processor_count => Optional[Integer],
  gpu_ppn => Optional[Integer],
}]
