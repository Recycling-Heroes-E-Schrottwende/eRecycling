import requests

def get_filtered_products(condition,categroy,transfer_method,location):


    api_url = "http://app.recyclingheroes.at/products/"

    response = requests.get(api_url)

    if response.status_code == 200:
        
        #http://app.recyclingheroes.at/products/?condition=New&transfer_method=Shipping&location=Vienna"

        print (requests.get("http://app.recyclingheroes.at/products/?condition="+condition+"&categroy="+categroy+"&transfer_method="+transfer_method+"&location="+location).json())

        print("API-Aufruf erfolgreich.")
    else:
        print(f"Fehler beim API-Aufruf. Statuscode: {response.status_code}")
        print(response.text)


get_filtered_products("New","","Shipping","Vienna")
