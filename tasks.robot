*** Settings ***
Documentation     Simple web scraper and price comparing robot

Library    RPA.Browser.Selenium    auto_close=${FALSE}
Library    RPA.FileSystem
Library    RPA.Desktop
Library    String
Library    OperatingSystem
Library    RPA.Tables
Library    RPA.Tables


*** Variables ***
${SAVEDIR}=    /Users/Artturi/Koodaus/vertailuRobo
${URL_VERKKOKAUPPA}=    https://www.verkkokauppa.com/fi/product/638239/Monster-Energy-Ultra-Violet-energiajuoma-500-ml-24-pack
${URL_FITNESSTUKKU}=    https://www.fitnesstukku.fi/24-x-monster-energy-ultra-50-cl-white/FP8765-4.html
${XPATH_PRICE_VERKKOKAUPPA}=    /html/body/div[1]/div/div/div/main/section/aside/div[2]/div[1]/div[2]/div[1]/span[1]/data
${SELECTOR_PRICE_FITNESSTUKKU}=    body > div.page > div.product.wrapper.container > div.product-top-content > div.product-detail.gtm-product-details > div.prices-and-availability > div.prices > div.price > div.price-adjusted


*** Tasks ***

save the price of goods
    
    Open Available Browser    ${URL_VERKKOKAUPPA}    headless=True
    ${PRICE_VERKKOKAUPPA}    Get Value    xpath=${XPATH_PRICE_VERKKOKAUPPA}
    Go To    ${URL_FITNESSTUKKU}
    ${PRICE_FITNESSTUKKU}    Get Text    css=${SELECTOR_PRICE_FITNESSTUKKU}
    Run Keyword    update_csv  ${PRICE_VERKKOKAUPPA}    ${PRICE_FITNESSTUKKU} 
    

*** Keywords ***

update_csv
    [Arguments]  ${price_verkkokauppa}    ${price_fitnesstukku}
    ${table}=  Read table from CSV    tiedot.csv
    Set table cell    ${table}    0    1       ${price_verkkokauppa}
    Set table cell    ${table}    1    1       ${price_fitnesstukku}
    Write table to CSV    table=${table}    path=/Users/Artturi/Koodaus/vertailuRobo/hinnat.csv    delimiter=;
