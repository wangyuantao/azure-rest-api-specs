# Use Summarization Oct Preview API

## Prerequisites
1. The current version of cURL. 
2. Azure subscription. 
    - Please [submit an online request and have it approved](https://aka.ms/applyforgatedsummarizationfeatures)
3. Create [Language resource](https://portal.azure.com/#create/Microsoft.CognitiveServicesTextAnalytics) via Azure portal.
    - Select the Subscription which is added into allowedlist.
    - Select `East US` as region.
    - Select `S` as pricing tier.
    - Create and note down the key and endpoint for later use.

## Features
[Document Abstractive Summarization](#document-abstractive-summarization)

The input is a string of plain text. The output is one or a few sentences. Use this feature to summarize news article, scientific paper, etc.

[Document Extractive Summarization](#document-extractive-summarization)

The input is a string of plain text. The output is one or a few sentences from the input. This is an existing feature but the model quality is improved in Oct Preview API. Also, we encourage customers migrate from the legacy Text Analytics endpoint to this Language endpoint.

[Conversation Chapters](#conversation-chapters)

The input is conversation transcript or chat messages. The output is chapter title. Use this feature to create table of content or bullet points of long conversation.

[Conversation Narrative](#conversation-narrative)

The input is also conversation transcript or chat messages. The output is one or a few sentences of summary. Use this feature to create call notes, meeting notes or chat summary. `conversationItems` `participantId` is required.

[Issue Resolution Summarization](#issue-resolution-summarization)

The input is also conversation transcript or chat messages. `conversationItems` `role` is required.

### Document Abstractive Summarization
1. Copy the command below into a text editor. The BASH example uses the `\` line continuation character. If your console or terminal uses a different line continuation character, use that character.
```
curl -i -X POST https://<your-language-resource-endpoint>/language/analyze-text/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>" \
-d \
' 
{
  "displayName": "Document Abstractive Summarization Task Example",
  "analysisInput": {
    "documents": [
      {
        "id": "1",
        "language": "en",
        "text": "At Microsoft, we have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding. As Chief Technology Officer of Azure AI Cognitive Services, I have been working with a team of amazing scientists and engineers to turn this quest into a reality. In my role, I enjoy a unique perspective in viewing the relationship among three attributes of human cognition: monolingual text (X), audio or visual sensory signals, (Y) and multilingual (Z). At the intersection of all three, there’s magic—what we call XYZ-code as illustrated in Figure 1—a joint representation to create more powerful AI that can speak, hear, see, and understand humans better. We believe XYZ-code will enable us to fulfill our long-term vision: cross-domain transfer learning, spanning modalities and languages. The goal is to have pre-trained models that can jointly learn representations to support a broad range of downstream AI tasks, much in the way humans do today. Over the past five years, we have achieved human performance on benchmarks in conversational speech recognition, machine translation, conversational question answering, machine reading comprehension, and image captioning. These five breakthroughs provided us with strong signals toward our more ambitious aspiration to produce a leap in AI capabilities, achieving multi-sensory and multilingual learning that is closer in line with how humans learn and understand. I believe the joint XYZ-code is a foundational component of this aspiration, if grounded with external knowledge sources in the downstream AI tasks."
      }
    ]
  },
  "tasks": [
    {
      "kind": "AbstractiveSummarization",
      "taskName": "Document Abstractive Summarization Task 1"
    }
  ]
}
'
```
2. Make the following changes in the command where needed:
    - Replace the value `your-language-resource-key` with your key.
    - Replace the first part of the request URL `your-language-resource-endpoint` with your endpoint URL.
3. Open a command prompt window (for example: BASH).
4. Paste the command from the text editor into the command prompt window, and then run the command.

5. Get the `operation-location` from the response header. The value will look similar to the following URL:
```
https://<your-language-resource-endpoint>/language/analyze-text/jobs/12345678-1234-1234-1234-12345678?api-version=2022-10-01-preview
```
6. To get the results of the request, use the following cURL command. Be sure to replace `<my-job-id>` with the GUID value you received from the previous `operation-location` response header:
```
curl -X GET https://<your-language-resource-endpoint>/language/analyze-text/jobs/<my-job-id>?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>"
```
Example JSON Response
```json
{
    "jobId": "cd6418fe-db86-4350-aec1-f0d7c91442a6",
    "lastUpdateDateTime": "2022-09-08T16:45:14Z",
    "createdDateTime": "2022-09-08T16:44:53Z",
    "expirationDateTime": "2022-09-09T16:44:53Z",
    "status": "succeeded",
    "errors": [],
    "displayName": "Document Abstractive Summarization Task Example",
    "tasks": {
        "completed": 1,
        "failed": 0,
        "inProgress": 0,
        "total": 1,
        "items": [
            {
                "kind": "AbstractiveSummarizationLROResults",
                "taskName": "Document Abstractive Summarization Task 1",
                "lastUpdateDateTime": "2022-09-08T16:45:14.0717206Z",
                "status": "succeeded",
                "results": {
                    "documents": [
                        {
                            "summaries": [
                                {
                                    "text": "Microsoft is taking a more holistic, human-centric approach to AI. We've developed a joint representation to create more powerful AI that can speak, hear, see, and understand humans better. We've achieved human performance on benchmarks in conversational speech recognition, machine translation, ...... and image captions.",
                                    "contexts": [
                                        {
                                            "offset": 0,
                                            "length": 247
                                        }
                                    ]
                                }
                            ],
                            "id": "1"
                        }
                    ],
                    "errors": [],
                    "modelVersion": "latest"
                }
            }
        ]
    }
}
```

If you do specify `parameters` `sentenceCount`, the model will try to predict the summaries in the length you specified. Note that the `sentenceCount` is just the approximate of sentences count of output summary, in range 1 to 20.

### Document Extractive Summarization
1. Copy the command below into a text editor. The BASH example uses the `\` line continuation character. If your console or terminal uses a different line continuation character, use that character.
```
curl -i -X POST https://<your-language-resource-endpoint>/language/analyze-text/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>" \
-d \
' 
{
  "displayName": "Document ext Summarization Task Example",
  "analysisInput": {
    "documents": [
      {
        "id": "1",
        "language": "en",
        "text": "At Microsoft, we have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding. As Chief Technology Officer of Azure AI Cognitive Services, I have been working with a team of amazing scientists and engineers to turn this quest into a reality. In my role, I enjoy a unique perspective in viewing the relationship among three attributes of human cognition: monolingual text (X), audio or visual sensory signals, (Y) and multilingual (Z). At the intersection of all three, there’s magic—what we call XYZ-code as illustrated in Figure 1—a joint representation to create more powerful AI that can speak, hear, see, and understand humans better. We believe XYZ-code will enable us to fulfill our long-term vision: cross-domain transfer learning, spanning modalities and languages. The goal is to have pre-trained models that can jointly learn representations to support a broad range of downstream AI tasks, much in the way humans do today. Over the past five years, we have achieved human performance on benchmarks in conversational speech recognition, machine translation, conversational question answering, machine reading comprehension, and image captioning. These five breakthroughs provided us with strong signals toward our more ambitious aspiration to produce a leap in AI capabilities, achieving multi-sensory and multilingual learning that is closer in line with how humans learn and understand. I believe the joint XYZ-code is a foundational component of this aspiration, if grounded with external knowledge sources in the downstream AI tasks."
      }
    ]
  },
  "tasks": [
    {
      "kind": "ExtractiveSummarization",
      "taskName": "Document Extractive Summarization Task 1",
      "parameters": {
        "sentenceCount": 6
      }
    }
  ]
}

'
```
2. Make the following changes in the command where needed:
    - Replace the value `your-language-resource-key` with your key.
    - Replace the first part of the request URL `your-language-resource-endpoint` with your endpoint URL.
3. Open a command prompt window (for example: BASH).
4. Paste the command from the text editor into the command prompt window, and then run the command.

5. Get the `operation-location` from the response header. The value will look similar to the following URL:
```
https://<your-language-resource-endpoint>/language/analyze-text/jobs/12345678-1234-1234-1234-12345678?api-version=2022-10-01-preview
```
6. To get the results of the request, use the following cURL command. Be sure to replace `<my-job-id>` with the GUID value you received from the previous `operation-location` response header:
```
curl -X GET https://<your-language-resource-endpoint>/language/analyze-text/jobs/<my-job-id>?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>"
```
Example JSON Response
```json
{
    "jobId": "56e43bcf-70d8-44d2-a7a7-131f3dff069f",
    "lastUpdateDateTime": "2022-09-28T19:33:43Z",
    "createdDateTime": "2022-09-28T19:33:42Z",
    "expirationDateTime": "2022-09-29T19:33:42Z",
    "status": "succeeded",
    "errors": [],
    "displayName": "Document ext Summarization Task Example",
    "tasks": {
        "completed": 1,
        "failed": 0,
        "inProgress": 0,
        "total": 1,
        "items": [
            {
                "kind": "ExtractiveSummarizationLROResults",
                "taskName": "Document Extractive Summarization Task 1",
                "lastUpdateDateTime": "2022-09-28T19:33:43.6712507Z",
                "status": "succeeded",
                "results": {
                    "documents": [
                        {
                            "id": "1",
                            "sentences": [
                                {
                                    "text": "At Microsoft, we have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding.",
                                    "rankScore": 0.69,
                                    "offset": 0,
                                    "length": 160
                                },
                                {
                                    "text": "In my role, I enjoy a unique perspective in viewing the relationship among three attributes of human cognition: monolingual text (X), audio or visual sensory signals, (Y) and multilingual (Z).",
                                    "rankScore": 0.66,
                                    "offset": 324,
                                    "length": 192
                                },
                                {
                                    "text": "At the intersection of all three, there’s magic—what we call XYZ-code as illustrated in Figure 1—a joint representation to create more powerful AI that can speak, hear, see, and understand humans better.",
                                    "rankScore": 0.63,
                                    "offset": 517,
                                    "length": 203
                                },
                                {
                                    "text": "We believe XYZ-code will enable us to fulfill our long-term vision: cross-domain transfer learning, spanning modalities and languages.",
                                    "rankScore": 1.0,
                                    "offset": 721,
                                    "length": 134
                                },
                                {
                                    "text": "The goal is to have pre-trained models that can jointly learn representations to support a broad range of downstream AI tasks, much in the way humans do today.",
                                    "rankScore": 0.74,
                                    "offset": 856,
                                    "length": 159
                                },
                                {
                                    "text": "I believe the joint XYZ-code is a foundational component of this aspiration, if grounded with external knowledge sources in the downstream AI tasks.",
                                    "rankScore": 0.49,
                                    "offset": 1481,
                                    "length": 148
                                }
                            ],
                            "warnings": []
                        }
                    ],
                    "errors": [],
                    "modelVersion": "latest"
                }
            }
        ]
    }
}
```


### Conversation Chapters
1. Copy the command below into a text editor. The BASH example uses the `\` line continuation character. If your console or terminal uses a different line continuation character, use that character.
```
curl -i -X POST https://<your-language-resource-endpoint>/language/analyze-conversations/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>" \
-d \
' 
{
  "displayName": "Conversation Task Example",
  "analysisInput": {
    "conversations": [
      {
        "conversationItems": [
          {
            "text": "Hello, you’re chatting with Rene. How may I help you?",
            "id": "1",
            "role": "Agent",
            "participantId": "Agent_1"
          },
          {
            "text": "Hi, I tried to set up wifi connection for Smart Brew 300 espresso machine, but it didn’t work.",
            "id": "2",
            "role": "Customer",
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
            "text": "Great. Thank you! Now, please check in your Contoso Coffee app. Does it prompt to ask you to connect with the machine? ",
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
        ],
        "modality": "text",
        "id": "conversation1",
        "language": "en"
      }
    ]
  },
  "tasks": [
    {
      "taskName": "Conversation Task 1",
      "kind": "ConversationalSummarizationTask",
      "parameters": {
        "summaryAspects": [
          "chapterTitle"
        ]
      }
    }
  ]
}
'
```
2. Make the following changes in the command where needed:
    - Replace the value `your-language-resource-key` with your key.
    - Replace the first part of the request URL `your-language-resource-endpoint` with your endpoint URL.
3. Open a command prompt window (for example: BASH).
4. Paste the command from the text editor into the command prompt window, and then run the command.

5. Get the `operation-location` from the response header. The value will look similar to the following URL:
```
https://<your-language-resource-endpoint>/language/analyze-conversations/jobs/12345678-1234-1234-1234-12345678?api-version=2022-10-01-preview
```
6. To get the results of the request, use the following cURL command. Be sure to replace `<my-job-id>` with the GUID value you received from the previous `operation-location` response header:
```
curl -X GET https://<your-language-resource-endpoint>/language/analyze-conversations/jobs/<my-job-id>?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>"
```
Example JSON Response
```json
{
  "jobId": "d874a98c-bf31-4ac5-8b94-5c236f786754",
  "lastUpdatedDateTime": "2022-09-29T17:36:42Z",
  "createdDateTime": "2022-09-29T17:36:39Z",
  "expirationDateTime": "2022-09-30T17:36:39Z",
  "status": "succeeded",
  "errors": [],
  "displayName": "Conversation Task Example",
  "tasks": {
    "completed": 1,
    "failed": 0,
    "inProgress": 0,
    "total": 1,
    "items": [
      {
        "kind": "conversationalSummarizationResults",
        "taskName": "Conversation Task 1",
        "lastUpdateDateTime": "2022-09-29T17:36:42.895694Z",
        "status": "succeeded",
        "results": {
          "conversations": [
            {
              "summaries": [
                {
                  "aspect": "chapterTitle",
                  "text": "Smart Brew 300 Espresso Machine WiFi Connection",
                  "contexts": [
                    { "conversationItemId": "1", "offset": 0, "length": 53 },
                    { "conversationItemId": "2", "offset": 0, "length": 94 },
                    { "conversationItemId": "3", "offset": 0, "length": 266 },
                    { "conversationItemId": "4", "offset": 0, "length": 85 },
                    { "conversationItemId": "5", "offset": 0, "length": 119 },
                    { "conversationItemId": "6", "offset": 0, "length": 21 },
                    { "conversationItemId": "7", "offset": 0, "length": 109 }
                  ]
                }
              ],
              "id": "conversation1",
              "warnings": []
            }
          ],
          "errors": [],
          "modelVersion": "latest"
        }
      }
    ]
  }
}

```
For long conversation, the model might segment it into multiple cohensive parts, and summarize each segment.
The `contexts` field for each summary indicates from which range of the input conversation we generated the summary.

### Conversation Narrative

1. Copy the command below into a text editor. The BASH example uses the `\` line continuation character. If your console or terminal uses a different line continuation character, use that character.
```
curl -i -X POST https://<your-language-resource-endpoint>/language/analyze-conversations/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>" \
-d \
' 
{
  "displayName": "Conversation Task Example",
  "analysisInput": {
    "conversations": [
      {
        "conversationItems": [
          {
            "text": "Hello, you’re chatting with Rene. How may I help you?",
            "id": "1",
            "role": "Agent",
            "participantId": "Agent_1"
          },
          {
            "text": "Hi, I tried to set up wifi connection for Smart Brew 300 espresso machine, but it didn’t work.",
            "id": "2",
            "role": "Customer",
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
            "text": "Great. Thank you! Now, please check in your Contoso Coffee app. Does it prompt to ask you to connect with the machine? ",
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
        ],
        "modality": "text",
        "id": "conversation1",
        "language": "en"
      }
    ]
  },
  "tasks": [
    {
      "taskName": "Conversation Task 1",
      "kind": "ConversationalSummarizationTask",
      "parameters": {
        "summaryAspects": [
          "narrative"
        ]
      }
    }
  ]
}
'
```
2. Make the following changes in the command where needed:
    - Replace the value `your-language-resource-key` with your key.
    - Replace the first part of the request URL `your-language-resource-endpoint` with your endpoint URL.
3. Open a command prompt window (for example: BASH).
4. Paste the command from the text editor into the command prompt window, and then run the command.

5. Get the `operation-location` from the response header. The value will look similar to the following URL:
```
https://<your-language-resource-endpoint>/language/analyze-conversations/jobs/12345678-1234-1234-1234-12345678?api-version=2022-10-01-preview
```
6. To get the results of the request, use the following cURL command. Be sure to replace `<my-job-id>` with the GUID value you received from the previous `operation-location` response header:
```
curl -X GET https://<your-language-resource-endpoint>/language/analyze-conversations/jobs/<my-job-id>?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>"
```
Example JSON Response
```json
{
  "jobId": "d874a98c-bf31-4ac5-8b94-5c236f786754",
  "lastUpdatedDateTime": "2022-09-29T17:36:42Z",
  "createdDateTime": "2022-09-29T17:36:39Z",
  "expirationDateTime": "2022-09-30T17:36:39Z",
  "status": "succeeded",
  "errors": [],
  "displayName": "Conversation Task Example",
  "tasks": {
    "completed": 1,
    "failed": 0,
    "inProgress": 0,
    "total": 1,
    "items": [
      {
        "kind": "conversationalSummarizationResults",
        "taskName": "Conversation Task 1",
        "lastUpdateDateTime": "2022-09-29T17:36:42.895694Z",
        "status": "succeeded",
        "results": {
          "conversations": [
            {
              "summaries": [
                {
                  "aspect": "narrative",
                  "text": "Agent_1 helps customer to set up wifi connection for Smart Brew 300 espresso machine.",
                  "contexts": [
                    { "conversationItemId": "1", "offset": 0, "length": 53 },
                    { "conversationItemId": "2", "offset": 0, "length": 94 },
                    { "conversationItemId": "3", "offset": 0, "length": 266 },
                    { "conversationItemId": "4", "offset": 0, "length": 85 },
                    { "conversationItemId": "5", "offset": 0, "length": 119 },
                    { "conversationItemId": "6", "offset": 0, "length": 21 },
                    { "conversationItemId": "7", "offset": 0, "length": 109 }
                  ]
                }
              ],
              "id": "conversation1",
              "warnings": []
            }
          ],
          "errors": [],
          "modelVersion": "latest"
        }
      }
    ]
  }
}
```
For long conversation, the model might segment it into multiple cohensive parts, and summarize each segment.
The `contexts` field for each summary indicates from which range of the input conversation we generated the summary.

### Issue Resolution Summarization


1. Copy the command below into a text editor. The BASH example uses the `\` line continuation character. If your console or terminal uses a different line continuation character, use that character.
```
curl -i -X POST https://<your-language-resource-endpoint>/language/analyze-conversations/jobs?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>" \
-d \
' 
{
  "displayName": "Conversation Task Example",
  "analysisInput": {
    "conversations": [
      {
        "conversationItems": [
          {
            "text": "Hello, you’re chatting with Rene. How may I help you?",
            "id": "1",
            "role": "Agent",
            "participantId": "Agent_1"
          },
          {
            "text": "Hi, I tried to set up wifi connection for Smart Brew 300 espresso machine, but it didn’t work.",
            "id": "2",
            "role": "Customer",
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
            "text": "Great. Thank you! Now, please check in your Contoso Coffee app. Does it prompt to ask you to connect with the machine? ",
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
        ],
        "modality": "text",
        "id": "conversation1",
        "language": "en"
      }
    ]
  },
  "tasks": [
    {
      "taskName": "Conversation Task 1",
      "kind": "ConversationalSummarizationTask",
      "parameters": {
        "summaryAspects": ["issue"]
      }
    },
    {
      "taskName": "Conversation Task 2",
      "kind": "ConversationalSummarizationTask",
      "parameters": {
        "summaryAspects": ["resolution"],
        "sentenceCount": 1
      }
    }
  ]
}
'
```

Note if `summaryAspects` is `resolution`, you can optionaly specify `sentenceCount` parameter to control the output summary length. If you don't specify the `sentenceCount`, the model will smartly determine the summary length. Only `resolution` aspect supports `sentenceCount`.

2. Make the following changes in the command where needed:
    - Replace the value `your-language-resource-key` with your key.
    - Replace the first part of the request URL `your-language-resource-endpoint` with your endpoint URL.
3. Open a command prompt window (for example: BASH).
4. Paste the command from the text editor into the command prompt window, and then run the command.

5. Get the `operation-location` from the response header. The value will look similar to the following URL:
```
https://<your-language-resource-endpoint>/language/analyze-conversations/jobs/12345678-1234-1234-1234-12345678?api-version=2022-10-01-preview
```
6. To get the results of the request, use the following cURL command. Be sure to replace `<my-job-id>` with the GUID value you received from the previous `operation-location` response header:
```
curl -X GET https://<your-language-resource-endpoint>/language/analyze-conversations/jobs/<my-job-id>?api-version=2022-10-01-preview \
-H "Content-Type: application/json" \
-H "Ocp-Apim-Subscription-Key: <your-language-resource-key>"
```
Example JSON Response
```json
{
  "jobId": "02ec5134-78bf-45da-8f63-d7410291ec40",
  "lastUpdatedDateTime": "2022-09-29T17:43:02Z",
  "createdDateTime": "2022-09-29T17:43:01Z",
  "expirationDateTime": "2022-09-30T17:43:01Z",
  "status": "succeeded",
  "errors": [],
  "displayName": "Conversation Task Example",
  "tasks": {
    "completed": 2,
    "failed": 0,
    "inProgress": 0,
    "total": 2,
    "items": [
      {
        "kind": "conversationalSummarizationResults",
        "taskName": "Conversation Task 1",
        "lastUpdateDateTime": "2022-09-29T17:43:02.3584219Z",
        "status": "succeeded",
        "results": {
          "conversations": [
            {
              "summaries": [
                {
                  "aspect": "issue",
                  "text": "Customer wants to connect their Smart Brew 300 to their Wi-Fi. | The Wi-Fi connection didn't work."
                }
              ],
              "id": "conversation1",
              "warnings": []
            }
          ],
          "errors": [],
          "modelVersion": "latest"
        }
      },
      {
        "kind": "conversationalSummarizationResults",
        "taskName": "Conversation Task 2",
        "lastUpdateDateTime": "2022-09-29T17:43:02.2099663Z",
        "status": "succeeded",
        "results": {
          "conversations": [
            {
              "summaries": [
                {
                  "aspect": "resolution",
                  "text": "Asked customer to check if the power light is blinking on and off every second."
                }
              ],
              "id": "conversation1",
              "warnings": []
            }
          ],
          "errors": [],
          "modelVersion": "latest"
        }
      }
    ]
  }
}
```
