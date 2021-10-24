RegisterNUICallback('getMoneyData', function(data, cb)
    if isLaundryOpen then
        print(data)
    end
    cb({})
end)