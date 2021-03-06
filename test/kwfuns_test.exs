defmodule KwfunsTest do
  use ExUnit.Case
  doctest Kwfuns

  defmodule A do
    use Kwfuns
    
    defkw plyer(factor, a: 1, b: 42) do
      factor * (a + b)
    end

    defkw adder(a: 1, b: 42) do
      a + b
    end

    defkwp private(a: 1), do: 2 * a
    def public(a), do: private(a: a)


    defkw required(a: kw_required, b: 1), do: a + b
  end

  test "adder" do
    assert A.adder(a: 40, b: 2) == 42 
  end
  test "order" do
    assert A.adder(b: 40, a: 2) == 42 
  end
  test "adder 1 default" do
    assert A.adder(b: 41) == 42
  end
  test "adder all defaults" do
    assert A.adder() == 43
  end

  test "plyer" do
    assert A.plyer(2) == 86
  end

  test "without kw params" do
    assert_raise ArgumentError, "do not use defkw but simply def if you do not have any default values", fn ->
      defmodule X do
        use Kwfuns
        defkw nop(), do: nil
      end
    end
  end

  test "private" do
    assert_raise UndefinedFunctionError, fn ->
      assert A.private
    end
  end

  test "private in scope" do
    assert A.public(21) == 42
  end

  test "required and provided" do
    assert A.required(a: 1) == 2

  end

  test "required and not provided" do
    assert_raise ArgumentError, "The following required keywords have not been provided: a", fn ->
      A.required(b: 1)
    end
  end
end

