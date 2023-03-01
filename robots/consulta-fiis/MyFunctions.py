def patrimonio_liquido_to_number(strPatrimonioLiquido):
    if "-" in strPatrimonioLiquido:
        return 0.0
    if "M" in strPatrimonioLiquido:
        strPatrimonioLiquidoAux = strPatrimonioLiquido.replace("M", "" ).strip()
        return br_currency_to_number(strPatrimonioLiquidoAux) * 1000000
    if "B" in strPatrimonioLiquido:
        strPatrimonioLiquidoAux = strPatrimonioLiquido.replace("B", "" ).strip()
        return br_currency_to_number(strPatrimonioLiquidoAux) * 1000000000

def br_currency_to_number(strBrCurrency):
        strBrCurrencyAux = strBrCurrency.replace("R$ ", "" ).strip()
        strBrCurrencyAux = strBrCurrencyAux.replace(".", "" ).strip()
        strBrCurrencyAux = strBrCurrencyAux.replace(",", "." ).strip()
        return round(float(strBrCurrencyAux),2) 
