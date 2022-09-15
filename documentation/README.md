# Use Summarization Oct Preview API

## Prerequisites
1. The current version of cURL. 
2. Azure subscription. 
    - Please tell us your Subscription ID first so we can add you to the allowlist, because this is a public gated preview feature. Don't know your Azure Subscription ID? See article for help: https://aka.ms/get-subscription-id
3. Create [Language resource](https://portal.azure.com/#create/Microsoft.CognitiveServicesTextAnalytics) via Azure portal.
    - Select the Subscription which is added into allowedlist.
    - Select `East US` as region.
    - Select `S` as pricing tier.
    - Create and note down the key and endpoint for later use.

## Features
[Document Abstractive Summarization](#document-abstractive-summarization)

The input is a string of plain text. The output is one or a few sentences. Use this feature to summarize news article, scientific paper, etc.

[Conversation Chapters](#conversation-chapters)

The input is conversation transcript or chat messages. The output is chapter title. Use this feature to create table of content or bullet points of long conversation.

[Conversation Narrative](#conversation-narrative)

The input is also conversation transcript or chat messages. The output is one or a few sentences of summary. Use this feature to create call notes, meeting notes or chat summary.

See more [public available summarization features](https://docs.microsoft.com/en-us/azure/cognitive-services/language-service/summarization/overview).

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
                                    "text": "Microsoft's AI cognitive services team is developing a new approach to learning and understanding that combines the best of both worlds.",
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

If you do not specify `parameters` `sentenceCount`, the model will predict output summary sentences count smartly.

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
            "text": "Hello, how can I help you?",
            "modality": "text",
            "id": "1",
            "participantId": "speaker1"
          },
          {
            "text": "How to upgrade Office? I am getting error messages the whole day.",
            "modality": "text",
            "id": "2",
            "participantId": "speaker2"
          },
          {
            "text": "Press the upgrade button please. Then sign in and follow the instructions.",
            "modality": "text",
            "id": "3",
            "participantId": "speaker1"
          },
          {
            "text": "I've tried that but it didn't work.",
            "modality": "text",
            "id": "4",
            "participantId": "speaker2"
          },
          {
            "text": "Can you describe the error you're seeing?",
            "modality": "text",
            "id": "5",
            "participantId": "speaker1"
          },
          {
            "text": "It says something about invalid license.",
            "modality": "text",
            "id": "6",
            "participantId": "speaker2"
          },
          {
            "text": "Please check that your license code is for the correct product version.",
            "modality": "text",
            "id": "7",
            "participantId": "speaker1"
          },
          {
            "text": "My next question is about the recent conference.",
            "modality": "text",
            "id": "8",
            "participantId": "speaker2"
          },
          {
            "text": "What are the highlights from the conference?",
            "modality": "text",
            "id": "9",
            "participantId": "speaker2"
          },
          {
            "text": "You can find a recap of the announcements made at the conference on our website.",
            "modality": "text",
            "id": "10",
            "participantId": "speaker1"
          },
          {
            "text": "What website are you referring to?",
            "modality": "text",
            "id": "11",
            "participantId": "speaker2"
          },
          {
            "text": "You can find more information at contoso.com/news.",
            "modality": "text",
            "id": "12",
            "participantId": "speaker1"
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
    "jobId": "13efaec1-896e-4da9-8b61-19db8408f26a",
    "lastUpdatedDateTime": "2022-09-14T16:39:10Z",
    "createdDateTime": "2022-09-14T16:39:08Z",
    "expirationDateTime": "2022-09-15T16:39:08Z",
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
                "lastUpdateDateTime": "2022-09-14T16:39:10.7359603Z",
                "status": "succeeded",
                "results": {
                    "conversations": [
                        {
                            "summaries": [
                                {
                                    "aspect": "chapterTitle",
                                    "text": "How to Upgrade Office"
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
There is also a lengthy `contexts` field for each summary, which means from which range of the input conversation we generated the summary.

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
            "text": "Hello, how can I help you?",
            "modality": "text",
            "id": "1",
            "participantId": "speaker1"
          },
          {
            "text": "How to upgrade Office? I am getting error messages the whole day.",
            "modality": "text",
            "id": "2",
            "participantId": "speaker2"
          },
          {
            "text": "Press the upgrade button please. Then sign in and follow the instructions.",
            "modality": "text",
            "id": "3",
            "participantId": "speaker1"
          },
          {
            "text": "I've tried that but it didn't work.",
            "modality": "text",
            "id": "4",
            "participantId": "speaker2"
          },
          {
            "text": "Can you describe the error you're seeing?",
            "modality": "text",
            "id": "5",
            "participantId": "speaker1"
          },
          {
            "text": "It says something about invalid license.",
            "modality": "text",
            "id": "6",
            "participantId": "speaker2"
          },
          {
            "text": "Please check that your license code is for the correct product version.",
            "modality": "text",
            "id": "7",
            "participantId": "speaker1"
          },
          {
            "text": "My next question is about the recent conference.",
            "modality": "text",
            "id": "8",
            "participantId": "speaker2"
          },
          {
            "text": "What are the highlights from the conference?",
            "modality": "text",
            "id": "9",
            "participantId": "speaker2"
          },
          {
            "text": "You can find a recap of the announcements made at the conference on our website.",
            "modality": "text",
            "id": "10",
            "participantId": "speaker1"
          },
          {
            "text": "What website are you referring to?",
            "modality": "text",
            "id": "11",
            "participantId": "speaker2"
          },
          {
            "text": "You can find more information at contoso.com/news.",
            "modality": "text",
            "id": "12",
            "participantId": "speaker1"
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
    "jobId": "19561f16-abbc-430a-a50f-e2cdd7f3d998",
    "lastUpdatedDateTime": "2022-09-14T16:42:35Z",
    "createdDateTime": "2022-09-14T16:42:31Z",
    "expirationDateTime": "2022-09-15T16:42:31Z",
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
                "lastUpdateDateTime": "2022-09-14T16:42:35.5714752Z",
                "status": "succeeded",
                "results": {
                    "conversations": [
                        {
                            "summaries": [
                                {
                                    "aspect": "narrative",
                                    "text": "speaker2 asks how to upgrade Office. speaker1 explains that the upgrade button is the correct product version."
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
There is also a lengthy `contexts` field for each summary, which means from which range of the input conversation we generated the summary.
