def verify_exact_contents(subject, title, expected_lines)
  content = subject.resource('file', title).send(:parameters)[:content]
  content.split("\n").reject { |line| line =~ /(^$|^#)/ }.should == expected_lines
end
