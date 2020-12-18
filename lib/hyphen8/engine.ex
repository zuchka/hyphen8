defmodule Hyphen8.Engine do

   def main(string) do
       string
       |> parse_words
       |> parse_characters
       |> match_against_key
       |> compile_coords
       |> filter_coords
       |> construct_hyphens
   end

   def parse_words(string) do
       Keyword.new
       |> Keyword.put_new(:words, String.split(string, ~r/\s|\\n|\\r|\\t|\W|_/, trim: true))
   end

   def parse_characters(data) do
       characters =
       Stream.map(data[:words],
          &String.split(&1, ~r/\w/, include_captures: true, trim: true))
       |> Stream.map(&Enum.join(&1, "0"))
       |> Stream.map(fn word -> "0#{word}0" end)

       Keyword.put_new(data, :characters, Enum.to_list(characters))
   end

   def match_against_key(data) do
       matches =
       Stream.map(data[:characters], fn word ->
          Stream.map(Hyphen8.Table.main, fn [regex, _list]              ->
          Regex.scan(regex, word, return: :index) end)
          |> Stream.reject(&Enum.empty?/1 )
          |> Stream.map(   &List.flatten/1)
          |> Enum.map(     &Enum.map(&1, fn {a, _b} -> a end))
       end)

       regex =
       Stream.map(data[:characters], fn word   ->
          Enum.flat_map(Hyphen8.Table.main, fn [regex, list]            ->
            case Regex.match?(regex, word) do
               :true  -> [list]
               :false -> []
            end
          end)
       end)

       Keyword.put_new(data, :matches, Enum.to_list(matches))
       |> Keyword.put_new(:regex, Enum.to_list(regex))
   end

   def compile_coords(data) do
       stream =
          Stream.zip(data[:matches], data[:regex]                             )
       |> Stream.map(&Tuple.to_list/1    )
       |> Stream.map(fn [match, regex] -> Enum.zip(     match, regex          )
       |> Stream.map(&Tuple.to_list/1    )
       |> Stream.map(fn [indices, tuples] -> Enum.map(indices, fn index      ->
          Enum.map(tuples, fn {a, b} -> {(a + index), b}           end)end)end)
       |> Enum.flat_map(&List.flatten/1)
       end)

       Keyword.put_new(data, :coordinates, Enum.to_list(stream))
   end

   def filter_coords(data) do
       stream =
          Stream.map(data[:coordinates], &Enum.uniq(&1)
       |> Stream.map(     fn tuple    -> Tuple.to_list(tuple) end)
       |> Stream.reject(  fn [  a,_b] -> a == 0               end)
       |> Stream.reject(  fn [  a,_b] -> a == 2               end)
       |> Enum.group_by(  fn [  a,_b] -> a                    end)
       |> Stream.map(     fn { _k, v} ->
          Enum.max_by(v,  fn [ _a, b] -> b end)               end)
       |> Enum.reject(    fn [ _a, b] -> rem(b, 2) == 0       end)
       )

       Keyword.put_new(data, :filtered, Enum.to_list(stream))
   end

   def construct_hyphens(data) do
       Stream.zip(data[:characters], data[:filtered])
       |> Stream.map(&Tuple.to_list/1)
       |> Stream.map(fn [word, coords] -> [String.split(word, "", trim: :true), Enum.map(coords, fn [a, _b] -> a end)]end)
       |> Stream.map(fn [word, coords] -> [List.to_tuple(word), coords]      end)
       |> Stream.map(fn [word, coords] -> Hyphen8.Recurse.main(word, coords) end)
       |> Stream.map(&Enum.reject(&1, fn x -> x == "0" end))
       |> Enum.join(" ")
   end
end
