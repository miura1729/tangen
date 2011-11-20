# -*- coding: cp932 -*-

require 'words.rb'
require 'study'

class CategoryWListTable
  def initialize
    @table = []
    (1..20).each do |n|
      @table[n] = Array.new
    end
  end

  def add(word, n)
    @table[n].push word
  end

  def get_word(n)
    wlist = @table[n]
    lsiz = wlist.size
    if lsiz == 0 then
      nil
    else
      wlist[rand(lsiz)]
    end
  end
end

class Word
  def initialize(word, size, category)
    @size = size
    @word = word
    @category = category
  end

  def get_word(n)
    if @size == n then
      @word
    else
      nil
    end
  end

  attr :word
end

CategoryPos = {:Noum => 0, :Verb => 1, :Adj => 2, :Postp => 3,
               :Noum_Hijiritu => 4, :Verb_Hijiritu => 5, :Adj_Hijiritu => 6}

Categories = {
  :Noum => CategoryWListTable.new,
  :Verb => CategoryWListTable.new,
  :Adj => CategoryWListTable.new,
  :Postp => CategoryWListTable.new,
  :Noum_Hijiritu => CategoryWListTable.new,
  :Verb_Hijiritu => CategoryWListTable.new,
  :Adj_Hijiritu => CategoryWListTable.new,
}

class TranslateTable
  TranslateCategoryInit = [
    # :Noum, :Verb, :Adj, :Postp :Norm_H :Verb_H :Adj_H
      [1,      3,    1,     5,    4,      0,      0],    # Noum
      [5,      1,    5,     0,    0,      4,      0],    # Verb
      [5,      1,    1,     0,    0,      0,      4],    # Adj
      [5,      3,    1,     0,    0,      0,      0],    # Postp
      [1,      3,    1,     5,    0,      0,      0],    # Noum_Hijiritu
      [5,      1,    5,     0,    0,      0,      0],    # Verb_Hijiritu
      [5,      1,    1,     0,    0,      0,      0],    # Adj_Hijiritu
  ]
  
  def initialize(word)
    @word = word
    @towords = {}
    @category = WORD_TABLE[word][1]
    @table = {}
    @total = 0
    Categories.each do |tokl, tab|
      fmpos = CategoryPos[@category]
      topos = CategoryPos[tokl]
      n = TranslateCategoryInit[fmpos][topos]
      @table[tab] = n
      @total += n
    end
  end
  
  def add(w_or_tab, weight = 1) 
    @total += weight
    @table[w_or_tab] = weight
  end

  def study_word(toword, val)
    tocatenm = WORD_TABLE[toword][1]
    tocategory = Categories[tocatenm]

    w = @table[tocategory]
    w0 = w + val
    if w0 < 0 then
      w0 = 0
    end
    @total += (w0 - w)
    @table[tocategory] = w0
  end

  def study_category(toword, val)
    if @towords[toword] == nil then
      @towords[toword] = Word.new(toword, *WORD_TABLE[toword])
    end
    w = @table[@towords[toword]] || 0
    w0 = w + val
    if w0 < 0 then
      w0 = 0
    end
    @total += (w0 - w)
    @table[@towords[toword]] = w0
  end

  def dump
    p @table
  end
  
  def get_next_word(n)
    wc = 0
    rnum = rand(@total)
    @table.each do |wot, weight|
      wc += weight
      if rnum <= wc then
        wd = wot.get_word(n)
        if wd then
          return wd
        end
      end
    end
    raise "Internal error maybe bugs"
  end
end

class TankaGen
  def initialize
    @translate_table = {}
    WORD_TABLE.each do |word, attr|
      size = attr[0]
      cate = attr[1]
      Categories[cate].add(word, size)
      @translate_table[word] = TranslateTable.new(word)
    end
  end
  
  def gen_ku(n)
    prev_word = nil
    result = []
    rest = n
    while rest > 0 do
      clen = 0
      word = nil
      begin
        clen = (rand(rest / 2) + rand((rest - 1) / 2) + 1).to_i
        if prev_word then
          word = @translate_table[prev_word].get_next_word(clen)
        else
          word = Categories[:Noum].get_word(clen)
        end
      end until word 
      prev_word = word
      result.push word
      rest -= clen
    end
    
    result
  end

  def study(w0, w1, weight)
    @translate_table[w0].study_word(w1, weight)
    @translate_table[w0].study_category(w1, weight)
    weight2 = Math.sqrt(weight.abs)
    if weight < 0 then
      weight2 = -weight2
    end
    wcate = WORD_TABLE[w0][1]
    WORD_TABLE.each do |word, info|
      if info[1] == wcate then
        @translate_table[word].study_category(w1, weight2)
      end
    end
  end

  def dump
    @translate_table.each {|word, tb| tb.dump}
  end
end

tg = TankaGen.new
study_all(tg)
print tg.gen_ku(5).join
print " "
print tg.gen_ku(7).join
print " "
print tg.gen_ku(5).join
print " "
print tg.gen_ku(7).join
print " "
print tg.gen_ku(7).join
