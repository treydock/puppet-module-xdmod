type Xdmod::Resource_Spec = Struct[{
  resource => String,
  start_date => Optional[String],
  end_date => Optional[String],
  processors => Integer,
  nodes => Integer,
  ppn => Integer,
}]
