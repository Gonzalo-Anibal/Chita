require 'net/http'
require 'open-uri'

class DocumentController < ApplicationController

    def index
    
    end

    def result
        client_dni = params[:client_dni]
        debtor_dni = params[:debtor_dni]
        document_amount = params[:document_amount]
        folio = params[:folio]
        expiration_date = params[:expiration_date]

        url = "https://chita.cl/api/v1/pricing/simple_quote?client_dni=#{client_dni}&debtor_dni=#{debtor_dni}&document_amount=#{document_amount}&folio=#{folio}&expiration_date=#{expiration_date}"

        request = URI.open(url,"X-Api-Key" => "UVG5jbLZxqVtsXX4nCJYKwtt")
        response = JSON.parse(request.read)

        @document_rate = response["document_rate"]
        @commission = response["commission"]
        @advance_percent = response["advance_percent"]
        
        @financing_cost = ( document_amount.to_i * (@advance_percent/100) ) * ( @document_rate / 30 * (( Date.parse(expiration_date) - Date.today).to_i  + 1 ))
        @turn_to_receive = ( document_amount.to_i *  (@advance_percent/100) ) - ( @financing_cost + @commission )
        @excedent = document_amount.to_i - ( document_amount.to_i * (@advance_percent/100) )
    end

end
