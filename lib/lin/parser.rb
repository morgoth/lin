require "strscan"

module Lin
  class Parser
    attr_reader :source

    def initialize(source)
      @source = source
    end

    # Returns cards for S hand
    #
    # @return [Array<String>]
    def s
      @s ||= parse_hand(parsed["md"][0].split(",")[0][1..-1])
    end

    # Returns cards for W hand
    #
    # @return [Array<String>]
    def w
      @w ||= parse_hand(parsed["md"][0].split(",")[1])
    end

    # Returns cards for N hand
    #
    # @return [Array<String>]
    def n
      @n ||= parse_hand(parsed["md"][0].split(",")[2])
    end

    # Returns cards for E hand
    #
    # @return [Array<String>]
    def e
      @e ||= deck - s - w - n
    end

    # Returns S player name
    #
    # @return [String]
    def s_name
      @s_name ||= players[0]
    end

    # Returns W player name
    #
    # @return [String]
    def w_name
      @w_name ||= players[1]
    end

    # Returns N player name
    #
    # @return [String]
    def n_name
      @n_name ||= players[2]
    end

    # Returns E player name
    #
    # @return [String]
    def e_name
      @e_name ||= players[3]
    end

    # Returns board name
    #
    # @return [String]
    def board_name
      @board_name ||= parsed["ah"][0]
    end

    # Returns dealer
    #
    # @return ["N", "E", "S", "W"]
    def dealer
      @dealer ||= case parsed["md"][0][0]
      when "1" then "S"
      when "2" then "W"
      when "3" then "N"
      when "4" then "E"
      end
    end

    # Returns bids
    #
    # @return [Array<String>]
    def bids
      @bids ||= parsed["mb"].map do |bid|
        case bid.upcase
        when "P" then "PASS"
        when "D" then "X"
        when "R" then "XX"
        when /\dN/ then bid[0] + "NT"
        else
          bid.upcase
        end
      end
    end

    # Returns played cards
    #
    # @return [Array<String>]
    def cards
      @cards ||= parsed["pc"]
    end

    # Returns claimed number of tricks
    #
    # @return [Integer, nil]
    def claim
      @claim ||= parsed["mc"][0] && parsed["mc"][0].to_i
    end

    # Returns vulnerable
    #
    # @return ["NONE" "NS", "EW", "BOTH"]
    def vulnerable
      @vulnerable ||= case parsed["sv"][0]
      when "n" then "NS"
      when "e" then "EW"
      when "b" then "BOTH"
      else
        "NONE"
      end
    end

    private

    def players
      @players ||= parsed["pn"][0].split(",")
    end

    def parsed
      return @parsed if defined?(@parsed)
      scanner = StringScanner.new(source)
      @parsed = Hash.new { |hash, key| hash[key] = [] }
      until scanner.eos?
        scanner.scan_until(/[\w]{2}\|[^\|]*\|/)
        key, value = retrieve_pair(scanner.matched)
        @parsed[key] << value
      end
      @parsed
    end

    # "md|some value here|", "md||"
    def retrieve_pair(source)
      result = source.split("|")
      [result[0], result[1]]
    end

    def parse_hand(hand)
      (hand.match(/S(.*?)H/)[1].split("").map { |value| "S" << value.upcase } <<
      hand.match(/H(.*?)D/)[1].split("").map { |value| "H" << value.upcase } <<
      hand.match(/D(.*?)C/)[1].split("").map { |value| "D" << value.upcase } <<
      hand.match(/C(.*?)$/)[1].split("").map { |value| "C" << value.upcase }).flatten
    end

    def deck
      ["SA", "SK", "SQ", "SJ", "ST", "S9", "S8", "S7", "S6", "S5", "S4", "S3", "S2", "HA", "HK", "HQ", "HJ", "HT", "H9", "H8", "H7", "H6", "H5", "H4", "H3", "H2", "DA", "DK", "DQ", "DJ", "DT", "D9", "D8", "D7", "D6", "D5", "D4", "D3", "D2", "CA", "CK", "CQ", "CJ", "CT", "C9", "C8", "C7", "C6", "C5", "C4", "C3", "C2"]
    end
  end
end
