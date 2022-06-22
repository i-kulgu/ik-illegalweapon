local Translations = {
    error = {
        incorrect_amount = "Incorrect amount",
        no_money = "Not enough money",
        cant_give = "Can't give item!",
        noweapon = "You dont have a weapon in your hands..",
        no_serie = "There is no serial number on this weapon",
    },
    target = {
        browse = "Browse Shop",
    },
    menu = {
        close = "❌ Close",
        cost = "Cost: $",
        weight = "Weight:",
        confirm = "Confirm Purchase",
        cpi = "Cost per item:",
        payment_type = "Payment Type",
        cash = "Cash",
        card = "Card",
        amount = "Amount to buy",
        submittext = "Pay",
        blackmoney = "Black Money",
     },
     choisemenu = {
        what = "What do you want",
        scratch = "Scratch Weapon Serial",
        buyweapon = "Buy Scratched Weapon",
        scratching = "Scratching serial numbers..",
        confirm = "Confirm",
     }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})