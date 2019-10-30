echo ""
echo "***********"
echo "create service in GCP SaaS instance"
echo ""
echo "pls provide the OI token (this is OI token not APM - Go to Service Overview Page of the OI. Open browser dev mode and go to request header section under network tab for a request (say click on status circle) and look for Authorization Bearer token )"
echo ""

read OI_TOKEN

if [ X"$OI_TOKEN" == "X" ]; then
   echo "Pls provide valid token"
   exit

fi

echo " "

echo " This will create an OI service - give it a minute or two and refresh your browser"

echo ""

curl -v -X POST \
  https://doi.dxi-na1.saas.broadcom.com/oi/v2/sa/save \
  -H 'Authorization: Bearer '$OI_TOKEN'' \
  -H 'Content-Type: application/json' \
  -H 'cache-control: no-cache' \
  -d '{
    "vertices": [
        {
            "attributes": {
                "host": "saService",
                "name": "TixChange Global US",
                "state": "ACTIVE",
                "serviceContent": [],
                "root_service": [
                    "TixChange Global US"
                ],
                "tags": [],
                "location": "",
                "description": "",
                "customProperties": []
            },
            "externalId": "TixChange Global US"
        },
        {
            "attributes": {
                "host": "saService",
                "name": "TixChange EastCoast DC",
                "state": "ACTIVE",
                "serviceContent": [
                    {
                        "query": [ 
			    {
                                "attributeName": "agent",
                                "attributeValue": "node2|apmiaMySQL_UC2|Agent"
                            }
                        ]
                    },
                    {
                        "query": [
			    {
                                "attributeName": "agent",
                                "attributeValue": "TxChangeWeb_UC2|tomcat|Agent"
                            }
                        ]
                    }
		],
                "root_service": [
                    "TixChange Global US"
                ],
                "tags": [],
                "location": "",
                "description": "",
                "customProperties": []
            },
            "externalId": "TixChange EastCoast DC"
        },
        {
            "attributes": {
                "host": "saService",
                "name": "TixChange WestCoast DC",
                "state": "ACTIVE",
                "serviceContent": [
		 {
                         "query": [
                             {
                                 "attributeName": "agent",
                                 "attributeValue": "TxChangeSvc_UC1|tomcat|Agent"
                             }
                        ]
                    },
                    {
                        "query": [ 
			    {
                                "attributeName": "agent",
                                "attributeValue": "node2|apmiaMySQL_UC1|Agent"
                            }
                        ]
                    },
                    {
                        "query": [
			    {
                                "attributeName": "agent",
                                "attributeValue": "TxChangeWeb_UC1|tomcat|Agent"
                            }
                        ]
                    }
		],
                "root_service": [
                    "TixChange Global US"
                ],
                "tags": [],
                "location": "",
                "description": "",
                "customProperties": []
            },
            "externalId": "TixChange WestCoast DC"
        },
        {
            "attributes": {
                "host": "saService",
                "name": "Event Management US",
                "state": "ACTIVE",
                "serviceContent": [
		 {
                         "query": [
                             {
                                 "attributeName": "agent",
                                 "attributeValue": "AuthServiceHost|tomcat|TixChangeAuthServiceAgent"
                             }
                        ]
                    }
		],
                "root_service": [
                    "TixChange Global US"
                ],
                "tags": [],
                "location": "",
                "description": "",
                "customProperties": []
            },
            "externalId": "Event Management US"
        }

            ],
    "edges": [
        {
            "targetExternalId": "TixChange EastCoast DC",
            "sourceExternalId": "TixChange Global US",
            "attributes": {
                "health_weight": 0.33299999999999996,
                "risk_weight": 0.33299999999999996,
                "semantic": "AggregateOf"
            }
        },
        {
            "targetExternalId": "TixChange WestCoast DC",
            "sourceExternalId": "TixChange Global US",
            "attributes": {
                "health_weight": 0.33299999999999996,
                "risk_weight": 0.33299999999999996,
                "semantic": "AggregateOf"
            }
        },
        {
            "targetExternalId": "Event Management US",
            "sourceExternalId": "TixChange Global US",
            "attributes": {
                "health_weight": 0.33299999999999996,
                "risk_weight": 0.33299999999999996,
                "semantic": "AggregateOf"
            }
        }
    ]
}
'

echo ""
