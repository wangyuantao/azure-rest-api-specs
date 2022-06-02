# Summarization API

## Document Summarization

### Request

1. Change endpoint `/text/analytics/v3.2-preview.1/analyze` to `/language/analyze-text/jobs?api-version=2022-10-01-preview`.
2. Introduce task kind as `ExtractiveSummarizationTask` instead of using top level `ExtractiveSummarizationTasks`.
3. Introduce new task kind: `AbstractiveSummarizationTask`.

```
curl -i -X POST https://your-text-analytics-endpoint-here/language/analyze-text/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: your-key-here" \
-d \
' 
{
  "analysisInput": {
    "documents": [
      {
        "language": "en",
        "id": "1",
        "text": "At Microsoft, we have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding. As Chief Technology Officer of Azure AI Cognitive Services, I have been working with a team of amazing scientists and engineers to turn this quest into a reality. In my role, I enjoy a unique perspective in viewing the relationship among three attributes of human cognition: monolingual text (X), audio or visual sensory signals, (Y) and multilingual (Z). At the intersection of all three, there’s magic—what we call XYZ-code as illustrated in Figure 1—a joint representation to create more powerful AI that can speak, hear, see, and understand humans better. We believe XYZ-code will enable us to fulfill our long-term vision: cross-domain transfer learning, spanning modalities and languages. The goal is to have pre-trained models that can jointly learn representations to support a broad range of downstream AI tasks, much in the way humans do today. Over the past five years, we have achieved human performance on benchmarks in conversational speech recognition, machine translation, conversational question answering, machine reading comprehension, and image captioning. These five breakthroughs provided us with strong signals toward our more ambitious aspiration to produce a leap in AI capabilities, achieving multi-sensory and multilingual learning that is closer in line with how humans learn and understand. I believe the joint XYZ-code is a foundational component of this aspiration, if grounded with external knowledge sources in the downstream AI tasks."
      }
    ]
  },
  "tasks": [
    {
      "kind": "ExtractiveSummarizationTask",
      "taskName": "analyze 1",
      "parameters": {
        "model-version": "latest",
        "sentenceCount": 3,
        "sortBy": "Offset"
      }
    },
    {
      "kind": "AbstractiveSummarizationTasks",
      "taskName": "analyze 2",
      "parameters": {
        "model-version": "latest"
      }
    }
  ]
}
'
```

### Response
Change endpoint `/text/analytics/v3.2-preview.1/analyze` to `/language/analyze-text/jobs?api-version=2022-10-01-preview`.
```
curl -X GET    https://your-text-analytics-endpoint-here/language/analyze-text/jobs/my-job-id?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: your-key-here"
```

Result schema is changed to reflect the task structure change.

```
{
   "jobId":"da3a2f68-eb90-4410-b28b-76960d010ec6",
   "lastUpdateDateTime":"2021-08-24T19:15:47Z",
   "createdDateTime":"2021-08-24T19:15:28Z",
   "expirationDateTime":"2021-08-25T19:15:28Z",
   "status":"succeeded",
   "errors":[],
   "displayName":"NA",
   "tasks":{
      "completed":2,
      "failed":0,
      "inProgress":0,
      "total":2,
      "items":[
         {
            "lastUpdateDateTime":"2021-08-24T19:15:48.0011189Z",
            "taskName":"analyze 1",
            "state":"succeeded",
            "results":{
               "documents":[
                  {
                     "id":"1",
                     "sentences":[
                        {
                           "text":"At Microsoft, we have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding.",
                           "rankScore":1.0,
                           "offset":0,
                           "length":160
                        },
                        {
                           "text":"In my role, I enjoy a unique perspective in viewing the relationship among three attributes of human cognition: monolingual text (X), audio or visual sensory signals, (Y) and multilingual (Z).",
                           "rankScore":0.9582327572675664,
                           "offset":324,
                           "length":192
                        },
                        {
                           "text":"At the intersection of all three, there’s magic—what we call XYZ-code as illustrated in Figure 1—a joint representation to create more powerful AI that can speak, hear, see, and understand humans better.",
                           "rankScore":0.9294747193132348,
                           "offset":517,
                           "length":203
                        }
                     ],
                     "warnings":[
                        
                     ]
                  }
               ],
               "errors":[
                  
               ],
               "modelVersion":"2021-08-01"
            }
         },
         {
           "lastUpdateDateTime":"2021-08-24T19:15:48.0011189Z",
           "taskName":"analyze 2",
           "state":"succeeded",
           "results":{
             "documents":[
               {
                 "id":"1",
                 "segments":[
                   {
                     "startIndex": 0,
                     "endIndex": 1629,
                     "text":"Microsoft have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding. The breakthroughs provided strong signals toward ambitious aspiration."
                   }
                 ],
                 "warnings":[]
               }
             ],
             "errors":[],
             "modelVersion":"2021-08-01"
           }
         }
      ]
   }
}
```

## Conversation Summarization

### Request

1. Add optional `startTime` to `conversationItem`.
2. Add new aspects `GeneralTitle` and `GeneralSummary`.
3. Add segmentation options.

```
curl -i -X POST https://your-language-endpoint-here/language/analyze-conversations/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: your-key-here" \
-d \
' 
{
    "displayName": "Analyze conversations from 123",
    "analysisInput": {
        "conversations": [
            {
                "modality": "text",
                "id": "conversation1",
                "language": "en",
                "conversationItems": [
                    {
                        "text": "Hello, you’re chatting with Rene. How may I help you?",
                        "id": "1",
                        "role": "Agent",
                        "startTime": "00:00:01",
                        "participantId": "Agent_1"
                    },
                    {
                        "text": "Hi, I tried to set up wifi connection for Smart Brew 300 espresso machine, but it didn’t work.",
                        "id": "2",
                        "role": "Customer",
                        "startTime": "00:00:21",
                        "participantId": "Customer_1"
                    },
                    {
                        "text": "I’m sorry to hear that. Let’s see what we can do to fix this issue. Could you please try the following steps for me? First, could you push the wifi connection button, hold for 3 seconds, then let me know if the power light is slowly blinking on and off every second?",
                        "id": "3",
                        "role": "Agent",
                        "participantId": "Agent_1"
                    },
                    {
                        "text": "Yes, I pushed the wifi connection button, and now the power light is slowly blinking.",
                        "id": "4",
                        "role": "Customer",
                        "participantId": "Customer_1"
                    },
                    {
                        "text": "Great. Thank you! Now, please check in your Contoso Coffee app. Does it prompt to ask you to connect with the machine?",
                        "id": "5",
                        "role": "Agent",
                        "participantId": "Agent_1"
                    },
                    {
                        "text": "No. Nothing happened.",
                        "id": "6",
                        "role": "Customer",
                        "participantId": "Customer_1"
                    },
                    {
                        "text": "I’m very sorry to hear that. Let me see if there’s another way to fix the issue. Please hold on for a minute.",
                        "id": "7",
                        "role": "Agent",
                        "participantId": "Agent_1"
                    }
                ]
            }
        ]
    },
    "tasks": [
        {
            "taskName": "analyze 1",
            "kind": "ConversationalSummarizationTask",
            "parameters": {
                "modelVersion": "latest",
                "segmentationOptions":
                {
                    "enabled": false,
                }
                "summaryAspects": [
                    "Issue",
                    "Resolution",
                    "GeneralTitle",
                    "GeneralSummary"
                ]
            }
        }
    ]
}
'
```

#### Response
1. Question to Mikael, why the endpoint is not `/language/analyze-conversations/jobs`?

```
curl -X GET    https://your-text-analytics-endpoint-here/text/analytics/v3.2-preview.1/analyze/jobs/my-job-id \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: your-key-here"
```

```
{
    "jobId": "738120e1-7987-4d19-af0c-89d277762a2f",
    "lastUpdatedDateTime": "2022-05-31T16:52:59Z",
    "createdDateTime": "2022-05-31T16:52:51Z",
    "expirationDateTime": "2022-06-01T16:52:51Z",
    "status": "succeeded",
    "errors": [],
    "displayName": "Analyze conversations from 123",
    "tasks": {
        "completed": 1,
        "failed": 0,
        "inProgress": 0,
        "total": 1,
        "items": [
            {
                "kind": "conversationalSummarizationResults",
                "taskName": "analyze 1",
                "lastUpdateDateTime": "2022-05-31T16:52:59.85913Z",
                "status": "succeeded",
                "results": {
                    "conversations": [
                        {
                            "id": "conversation1",
                            "segments":[
                                {
                                    "ids": ["1", "2", "3", "4", "5", "6", "7"]
                                    "summaries": [
                                        {
                                            "aspect": "issue",
                                            "text": "Customer tried to set up wifi connection for Smart Brew 300 machine, but it didn't work"
                                        },
                                        {
                                            "aspect": "resolution",
                                            "text": "Asked customer to try the following steps | Asked customer for the power light | Checked if the app is prompting to connect to the machine | Transferred the call to a tech support"
                                        },
                                        {
                                            "aspect": "generalTitle",
                                            "text": "Machine Connection Prompting"
                                        },
                                        {
                                            "aspect": "generalSummary",
                                            "text": "Customer_1 asked the wifi connection issue, and Agent_1 asked Customer_1 to check the Contoso app."
                                        }
                                    ],
                                }
                            ]
                            
                            "warnings": []
                        }
                    ],
                    "errors": [],
                    "modelVersion": "2022-05-15-preview"
                }
            }
        ]
    }
}
```

## Appendix: Exiting API in preview
https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/summarization/quickstart
