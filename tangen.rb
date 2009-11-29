# -*- coding: cp932 -*-

class KlassWListTable
  def initialize
    @table = []
    (1..7).each do |n|
      @table[n] = Array.new
    end
  end

  def add(word, n)
    @table[n].push word
  end

  def get_word(n)
    wlist = @table[n]
    lsiz = wlist.size
    wlist[rand(lsiz)]
  end
end

class Word
  def initiailize(word, klass)
    @word = word
    @klass = klass
  end

  def get_word(n)
    @word
  end
end

Klasses = {
  :Noum => KlassWListTable.new,
  :Verb => KlassWListTable.new,
  :Adj => KlassWListTable.new,
  :Postp => KlassWListTable.new,
}

class TranslateTable
  def initalize(word)
    @word = word
    @table = []
    @total = 0
  end

  def add(w_or_tab, weight = 1) 
    @total += weight
    @table.push [w_or_tab, weight]
  end

  def get_next_word(n)
    wc = 0
    @table.each do |wot, weight|
      wc += weight
      if rand(@total) < wc then
        return wot.get_word(n)
      end
    end
    raise "Internal error maybe bugs"
  end
end

WORD_TABLE = [
  ["�R", 2, :Noum],
  ["��", 2, :Noum],
  ["���", 3, :Noum],
  ["������", 4, :Noum],
  ["�j", 3, :Noum],
  ["��", 3, :Noum],
  ["�L", 2, :Noum],
  ["��", 2, :Noum],

  ["����", 3, :Verb],
  ["����", 3, :Verb],
  ["�R����", 3, :Verb],
  ["�����", 4, :Verb],

  ["����", 3, :Adj],
  ["�Ԃ�", 3, :Adj],
  ["������", 4, :Adj],

  ["��", 1, :Postp],
  ["��", 1, :Postp],
  ["��", 1, :Postp],
  ["��", 1, :Postp],
]

WORD_TABLE.each do |word, size, klass|
  Klasses[klass].add(word, size)
end

p Klasses[:Noum].get_word(3)
