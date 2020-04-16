import requests
import Headers


class ApiRequests:
    
    def __init__(self, name, areaID, availableSlots, orientation, coords):
        
        self.path = coords
        self.data = {'name': name, 'areaID': areaID, 'avaibleSlots': availableSlots, 'orientation' : orientation, 'path': self.path}
        
    def createParkinglot(self):
        
        url = Headers.urlCreateArea
        return requests.post(url = url, headers = Headers.headers, json = self.data, timeout=(2,5))
    
    
def createParkingSpots(parkingareaID, spots):
    
    url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot/{parkingareaID}/grid/create'
    return requests.post(url = url, headers = Headers.headers, json = spots, timeout=(2, 5))

def toggleAvailability(parkingareaID, updates):
    url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot/{parkingareaID}/grid/setAvaibleGrids' 
    #url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot/{parkingareaID}/grid/toggleMultipleStates'
    return requests.patch(url = url, headers = Headers.headers, json = updates, timeout=(2, 5))
    
        
def getParkinglot(parkinglotID): 
        url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/{parkinglotID}/'
        return requests.get(url = url, headers = Headers.headers, timeout=(2, 5))
    
def deleteParkinglot(parkinglotID): 
        url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/{parkinglotID}/'
        return requests.delete(url = url, headers = Headers.headers, timeout=(2, 5))
        
        