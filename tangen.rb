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
  ["山", 2, :Noum],
  ["川", 2, :Noum],
  ["列車", 3, :Noum],
  ["自動車", 4, :Noum],
  ["男", 3, :Noum],
  ["女", 3, :Noum],
  ["猫", 2, :Noum],
  ["犬", 2, :Noum],

  ["走る", 3, :Verb],
  ["歩く", 3, :Verb],
  ["燃える", 3, :Verb],
  ["流れる", 4, :Verb],

  ["白い", 3, :Adj],
  ["赤い", 3, :Adj],
  ["美しい", 4, :Adj],

  ["は", 1, :Postp],
  ["が", 1, :Postp],
  ["の", 1, :Postp],
  ["と", 1, :Postp],
]

WORD_TABLE.each do |word, size, klass|
  Klasses[klass].add(word, size)
end

p Klasses[:Noum].get_word(3)
