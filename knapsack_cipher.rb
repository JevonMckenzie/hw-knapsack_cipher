require 'prime'
require './modular_arithmetic.rb'

class SuperKnapsack
  attr_accessor :knapsack

  def self.array_sum(arr)
    arr.reduce(:+)
  end

  def initialize(arr)
    arr.each.with_index do |a, i|
      unless i == 0
        if (a <= self.class.array_sum(arr[0..i-1])) then
          raise(ArgumentError, "not superincreasing at index #{i}")
        end
      end
      @knapsack = arr
    end
  end

  def primes?(m, n)
    Prime.prime?(m) && Prime.prime?(n)
  end

  def to_general(m, n)
    argError = 'arguments must both be prime' if !primes?(m, n)
    argError = "#{n} is smaller than superincreasing knapsack" if n <= @knapsack.last
    raise(ArgumentError, argError) unless argError.nil?
    @knapsack.map { |a| (a * m) % n }
  end
end
#
class KnapsackCipher
  # Default values of knapsacks, primes
  M = 41
  N = 491
  DEF_SUPER = SuperKnapsack.new([2, 3, 7, 14, 30, 57, 120, 251])
  DEF_GENERAL = DEF_SUPER.to_general(M, N)

  # Encrypts plaintext
  # Params:
  # - plaintext: String object to be encrypted
  # - generalknap: Array object containing general knapsack numbers
  # Returns:
  # - Array of encrypted numbers
  def self.encrypt(plaintext, generalknap=DEF_GENERAL)
    # TODO: implement this method
    binary = []
    cipher = Array.new(plaintext.length, 0)
    i = 0
    plaintext.each_char.map{|x| binary << x.ord.to_s(2) }
    binary = binary.map { |x|
      '0' * (generalknap.length - x.length) << x if x.length < generalknap.length }
    binary.each_with_index{ |bin, idx|
                    bin.each_char{ |x|
                      if x == '1'
                        cipher[idx] += generalknap[i]
                      end
                      i += 1
                      if i == generalknap.length
                        i = 0
                      end
                    }}
    cipher
  end

  # Decrypts encrypted Array
  # Params:
  # - cipherarray: Array of encrypted numbers
  # - superknap: SuperKnapsack object
  # - m: prime number
  # - n: prime number
  # Returns:
  # - String of plain text
  def self.decrypt(cipherarray, superknap=DEF_SUPER, m=M, n=N)
    raise(ArgumentError, "Argument should be a SuperKnapsack object"
    ) unless superknap.is_a? SuperKnapsack

      knap = superknap.knapsack.reverse
      mod_inv = ModularArithmetic.invert(m, n)
      plain_text = cipherarray.map { |e| e * mod_inv % n }
      plain_text = plain_text.map { |e| decipher(e, knap) }.join
  end

  def self.decipher( num, knap )
      ord = knap.map do |x|
        if num >= x
          num = num - x
          1
          else
          0
        end
      end.reverse.join
      character = ord.to_i(2).chr
  end

end
