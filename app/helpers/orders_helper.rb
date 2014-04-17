module OrdersHelper
    def pretty(order)
        order.name = order.name.titleize
        order.bunk=order.bunk.capitalize
        match_data = /([A,a,B,b])(\d{1,2})/.match order.bunk
        if match_data
            order.bunk = "#{match_data[1].capitalize}-#{match_data[2]}"
        end
    end

end
