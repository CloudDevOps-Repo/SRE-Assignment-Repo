import json
import random
import boto3

def lambda_handler(event, context):
    
    ##########DynamoDb table clear########
    dynamodb=boto3.resource('dynamodb')
    table=dynamodb.Table('Dice_Simulation_Results')
    
    results= table.scan() #retrive datastore dice results 
    
    #print('TotalItems:'+str(results['Count']))
    Items=results['Items'] # Storing the json result of simulation results
    
    #r1=Items[0]
    siml_count = [] #list to store the simulation counts
    dice_roll_total=[] #list to store the dice roll total 
    for x in range(len(Items)):
        siml_count.append(Items[x]["dice_simul_seq"])
        #print(Items[x]["dice_simul_seq"])
        dice_roll_total.append(Items[x]["dice_roll_total"])

 
    responsbody=('There were a total of '+str(len(set(siml_count)))+' simulations, with a total of '+str(results['Count'])+' rolls for this combination'+"\n")
    #print (responsbody)
    
    dice_roll_total.sort() #Sort the dice totals result
    dict_dice_roll_total = {}
    for i in dice_roll_total:
        if i in dict_dice_roll_total: dict_dice_roll_total[i] += 1
        else: dict_dice_roll_total[i] = 1
    
    for key in dict_dice_roll_total: #calculate the probablity of results
        #print(str(key)+' was rolled '+str(dict_dice_roll_total[key])+' times, that would be '+str(round((dict_dice_roll_total[key]/results['Count'])*100,2))+'%')
        responsbody=responsbody+(str(key)+' was rolled '+str(dict_dice_roll_total[key])+' times, that would be '+str(round((dict_dice_roll_total[key]/results['Count'])*100,2))+'%'+"\n")
        
    print (responsbody) #print response body for logs
    
    
    #5 Response Object
    respondJson={}
    respondJson['statusCode']=200
    respondJson['headers']={}
    respondJson['headers']['content-type']='application/json'
    respondJson['body']=json.dumps(responsbody)
    
    
    
    # Response from lambda
    return respondJson