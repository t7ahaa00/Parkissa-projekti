import requests
import headers


class ApiRequests:
    
    def __init__(self, name, areaID, availableSlots, orientation, coords):
        
        self.path = coords
        self.data = {'name': name, 'areaID': areaID, 'avaibleSlots': availableSlots, 'orientation' : orientation, 'path': self.path}
        
    def createParkinglot(self):
        
        url = headers.urlCreateArea
        return requests.post(url = url, headers = headers.headers, json = self.data, timeout=(2,5))
    
    
def createParkingSpots(parkinglotID, parkingareaID, spots):
    
    url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/{parkinglotID}/{parkingareaID}/grid/create'
    return requests.post(url = url, headers = headers.headers, json = spots, timeout=(2, 5))

def toggleAvailability(parkingareaID, updates):
    url = f'https://kfcuuczfr2.execute-api.eu-west-1.amazonaws.com/front_tests/parkinglot/{parkingareaID}/grid/toggleMultipleStates'
    return requests.patch(url = url, headers = headers.headers, json = updates, timeout=(2, 5))
    
        
        
        
        
        