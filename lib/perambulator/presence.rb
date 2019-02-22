module Perambulator
  module Presence
    def peram_presence
      peram_present? ? self : nil
    end

    def peram_present?
      !peram_blank?
    end

    def peram_blank?
      respond_to?(:empty?) ? empty? == true : !self
    end
  end
end
