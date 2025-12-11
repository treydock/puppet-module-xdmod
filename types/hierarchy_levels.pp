type Xdmod::Hierarchy_Levels = Struct[{
  top => Struct[{
    label => String,
    info  => String,
  }],
  Optional[middle] => Struct[{
    label => String,
    info  => String,
  }],
  Optional[bottom] => Struct[{
    label => String,
    info  => String,
  }],
}]
