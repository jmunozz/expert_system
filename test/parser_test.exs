defmodule ParserTest do
  use ExUnit.Case

  # test "A+B" do
	# assert Parser.parse("A+B") == {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}
  # end
  #
  # test "((A+B)|C)^B" do
	# assert Parser.parse("((A+B)|C)^B") == {:branch, "^", {:branch, "|", {:branch, "+", {:leaf, "A"}, {:leaf, "B"}}, {:leaf, "C"}}, {:leaf, "B"}}
  # end
  #
  # test "A+B|C=>D" do
	# assert Parser.parse("A+B|C=>D") ==
	# 	{ :branch, "=>",
	# 	 	{ :branch, "|",
	# 		 	{ :branch, "+",
	# 			 { :leaf, "A" },
	# 			 { :leaf, "B" }
	# 			},
	# 			{ :leaf, "C"}
	# 		},
	# 		{ :leaf, "D" }
	# 	}
  # end

  test "test3" do
	assert Parser.parse("A+B|(C=>D)") ==
		{ :branch, "|",
		 	{ :branch, "+",
			 	{ :leaf, "A" },
				{ :leaf, "B" }
			},
			{ :branch, "=>",
				{ :leaf, "C"},
				{ :leaf, "D" }
			}
		}
  end

end
