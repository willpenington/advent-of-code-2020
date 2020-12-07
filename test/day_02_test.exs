defmodule Day02Test do
  use ExUnit.Case, async: true
  doctest AdventOfCode.Day02

  alias AdventOfCode.Day02
  alias AdventOfCode.Day02.Record

  test "parse string into rule" do
    assert Day02.extract_record("1-3 a: abcde") == %Record{from: 1, to: 3, char: "a", password: "abcde"}
    assert Day02.extract_record("1-3 b: cdefg") == %Record{from: 1, to: 3, char: "b", password: "cdefg"}
    assert Day02.extract_record("2-9 c: ccccccccc") == %Record{from: 2, to: 9, char: "c", password: "ccccccccc"}
  end

  test "valid password matches by count rule" do
    assert Day02.password_matches_by_count(%Record{from: 1, to: 3, char: "a", password: "abcde"})
    assert Day02.password_matches_by_count(%Record{from: 2, to: 9, char: "c", password: "ccccccccc"})
  end

  test "invalid password fails match by count" do
    assert Day02.password_matches_by_count(%Record{from: 1, to: 3, char: "b", password: "cdefg"}) == false
    assert Day02.password_matches_by_count(%Record{from: 1, to: 3, char: "b", password: "cbbdbefgb"}) == false
  end

  test "valid password matches by possition rule" do
    assert Day02.password_matches_by_position(%Record{from: 1, to: 3, char: "a", password: "abcde"})
  end

  test "password match by position fails when neither position contains the character" do
    assert Day02.password_matches_by_position(%Record{from: 1, to: 3, char: "b", password: "cdefg"}) == false
  end

  test "password match by position fails when both positions contains the character" do
    assert Day02.password_matches_by_position(%Record{from: 2, to: 9, char: "c", password: "ccccccccc"}) == false
  end

end
