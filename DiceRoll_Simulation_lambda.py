import json
import random
import boto3
import datetime

def lambda_handler(event, context):
    
    ##########DynamoDb table invoke########
    dynamodb=boto3.resource('dynamodb')
    table=dynamodb.Table('Dice_Simulation_Results')
    
    
    #1 Reading Query String Parameters 
    #print('Start......event data print ')
    #print(event)
    #print('Start......event data print ')
    dicesides=event['queryStringParameters']['dice_sides']
    no_of_dice=event['queryStringParameters']['no_of_dices']
    no_of_simulations=event['queryStringParameters']['no_of_simulations']
    
    dice_simul_seq=datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')    # to maintain unique simulation trigger sequence number
    
    #dicesides=6
    #no_of_dice=3
    #no_of_simulations=5
    
    
    """
    #dynamodb all items from table
    scan = table.scan()
    with table.batch_writer() as batch:
        for each in scan['Items']:
            batch.delete_item(
                Key={
                    'DiceID': each['rowid']
                }
            )
    """
    dict={} #dictoionary to store the simulation results to populate dynamodb item
    dicenum=1
    diceresult=''
    #dicesimulate=5 #Input NoOf Simulations
    DiceResponse=''
    dice_sim_cnt=1 #variable for simulations loop
    while (dice_sim_cnt<=int(no_of_simulations)):
        #print('dicesimcnt:'+str(dicesimcnt))
        header=''#'RollNo'
        diceresult='' #Dice Roll result
        dicenum=1  #dice number
        dicetot=0  #dice result calculator per similation
        diceface=0 #dice facevalue after roll(random number based on sides)
        #dict["DiceID"]=str(dice_sim_cnt)
        
        while (dicenum<=int(no_of_dice)):
            diceface=random.randint(1,int(dicesides))
            diceresult=diceresult+"'"+str(diceface)+"',"
            dict["Dice_"+str(dicenum)]=str(diceface)
            dicetot=dicetot+int(diceface)
            if (dice_sim_cnt==1):
                header=header+'diceno'+str(dicenum)+','
            dicenum=dicenum+1
        if (dice_sim_cnt==1):
           print ('DiceSimSeqNo,'+header+'DiceSimTot')
           DiceResponse='DiceSimSeqNo,'+header+'DiceSimTot'+'\n'
        print ('Simulation:'+str(dice_sim_cnt)+',',diceresult+str(dicetot))
        #DiceResponse=DiceResponse+ 'Simulation'+str(dice_sim_cnt)+': '+diceresult+str(dicetot)+'\n'
        DiceResponse=DiceResponse+str(dict)+','
        
        dict['dice_simul_seq']=str(dice_simul_seq)
        dict['rowid']=str(datetime.datetime.now().strftime('%Y%m%d%H%M%S%f')) #unique id for dynamodb table primary key
        dict['dice_roll_total']=str(dicetot)
        print(dict)
        table.put_item(Item =dict) #insert simulation roll to dynamodb table
        dice_sim_cnt=dice_sim_cnt+1
        dict.clear() #clear dictonary to get new row item 
    
       
    print(DiceResponse)
    calcRespose={}
    calcRespose['DiceResponse']=DiceResponse
    calcRespose['status']='sucess from lambda-v2!!!'
    
    #Response Object
    respondJson={}
    respondJson['statusCode']=200
    respondJson['headers']={}
    respondJson['headers']['content-type']='application/json'
    respondJson['body']=json.dumps(calcRespose)
    
    
    
    # TODO implement
    return respondJson