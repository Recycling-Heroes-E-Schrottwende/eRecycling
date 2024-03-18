import requests

def get_filtered_products(condition,categroy,transfer_method,postcode):


    api_url = "http://app.recyclingheroes.at/products/"

    response = requests.get(api_url)

    if response.status_code == 200:
        
        #http://app.recyclingheroes.at/api/products/?condition=New&transfer_method=Shipping&postcode=1200"

        print (requests.get("http://app.recyclingheroes.at/products/?condition="+condition+"&categroy="+categroy+"&transfer_method="+transfer_method+"&postcode="+postcode).json())

        print("API-Aufruf erfolgreich.")
    else:
        print(f"Fehler beim API-Aufruf. Statuscode: {response.status_code}")
        print(response.text)


get_filtered_products("New","","Shipping","test")
