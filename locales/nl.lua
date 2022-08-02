local Translations = {
    error = {
        incorrect_amount = "Onjuist aantal",
        no_money = "Niet genoeg geld",
        cant_give = "Kan item niet geven!",
        noweapon = "Je hebt geen wapen in je handen..",
        no_serie = "Er is geen serienummer op deze wapen",
    },
    target = {
        browse = "Winkel Bekijken",
    },
    menu = {
        close = "❌ Sluiten",
        cost = "Kosten: $",
        weight = "Gewicht:",
        confirm = "Bevestig aankoop",
        cpi = "Kosten per stuk: ",
        sp = "Scratch prijs: ",
        payment_type = "Betalingswijze",
        cash = "Cash",
        card = "Kaart",
        amount = "Te kopen aantal",
        submittext = "Betalen",
        blackmoney = "Zwart Geld",
     },
     choisemenu = {
        what = "Wat moet je",
        scratch = "Serienummer Verwijderen",
        buyweapon = "Koop Illegale Wapen",
        scratching = "Serie nummer verwijderen..",
        confirm = "Bevestigen",
     }
}

Lang = Locale:new({
    phrases = Translations,
    warnOnMissing = true
})