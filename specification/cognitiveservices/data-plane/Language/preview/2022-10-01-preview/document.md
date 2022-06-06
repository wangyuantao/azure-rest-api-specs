# Summarization API

## api-version
`2022-10-01-preview`

## Endpoint and Task Kind

| | | | 
| --- | --- | --- |
| Endpoint | `/language/analyze-text/` | `/language/analyze-conversations/` |
| Task Kind | `DocumentSummarizationTask` | `ConversationalSummarizationTask` |

## Request Schema
For both `DocumentSummarizationTask` and `ConversationalSummarizationTask`, the request body use the same schema `SummarizationTask`.

| Parameter | Type | Valid Values | Default Value | Validation |
| --- | --- | --- | --- | --- |
| genre | enum | generic<br/>callcenter | generic | `callcenter` can only be used for `ConversationalSummarizationTask` | 
| aspects | enum[] | issue<br/>resolution<br/>title<br/>generic | [generic] | <ol><li>`issue` and `resolution` can only be used when genre=`callcenter`</li><li> `title` and `generic` can only be used when genre=`generic` and in `ConversationalSummarizationTask`</li></old> |
| abstractiveness | enum | extractive<br/>abstractive |  | Required |
| length | enum | short<br/>medium<br/>long<br/> | medium | Can only set if abstractiveness=`abstractive` and in `DocumentSummarizationTask` |
| sentenceCount | int | [1,20] | 3 | Can only set if abstractiveness=`extractive` | |
| sortBy | enum | Offset,Rank | Offset | Can only set if abstractiveness=`extractive` | |

## Scenario Mapping
Below table shows how to map summarization scenarios to different task and parameters.

| Scenario | task | genre | aspects | abstractiveness |
| --- | --- | --- | --- | --- |
| Document Extractive | DocumentSummarizationTask | generic | ["generic"] | extractive |
| Document Abstractive | DocumentSummarizationTask | generic | ["generic"] | abstractive |
| Issue & Resolution | ConversationalSummarizationTask | callcenter | ["issue","resolution"] | abstractive |
| Chapters & Notes | ConversationalSummarizationTask | generic | ["title", "generic"] | abstractive |

## ConversationalSummarizationTask aspects
* For callcenter genre, user can set aspects as ["issue"] or ["resolution"] as well
* For generic genre, user can set aspects as ["title"] or ["generic"] as well


## Context Selection

* We are not going to expose the segmentation as options.

* Topic segmentation is applied automatically if and only if genre=`generic` in `ConversationalSummarizationTask`.

* In future, we might use context selection algorithm other than topic segmentation.

| Scenario | Context |
| --- | --- |
| Document Extractive | Extracted Sentences themselves |
| Document Abstractive | The whole document (TBD are we able to have document segmentation before Ignite?) |
| Issue & Resolution | The whole conversation |
| Chapters & Notes | Topic segmentation result |

## Input Document Schema

| Field | Type | Validation |
| --- | --- | --- |
| language | enum | |
| id | string | |
| text | string | TBD |

## Input Conversation Schema

| Field | Type | Validation |
| --- | --- | --- |
| language | enum | |
| id | string | |
| conversations | ConversationItem[] | TBD |

## Conversation Item Schema

| Field | Type | Validation |
| --- | --- | --- |
| id | string | No duplication, it will be referenced in summary context |
| text | string | TBD |
| role | enum | Must and can only be used for callcenter genre: valid values are `Agent` and `Customer`|
| participantId | string | Length > 0 |
| startTime | DateTime | Optional. If present, must present for all items and sorted |
| duration | TimeSpan | Optional. If present on any item, `startTime` must present on that item as well |

## Summary Schema

| Field | Type | Description |
| --- | --- | --- |
| id | string | Reference the input document id or input conversation id |
| summaries | SummaryItem[] |  |

## Summary Item Schema

For each input document or conversation, we produce multiple summary items.

| Field | Type | Description |
| --- | --- | --- |
| aspect | enum | One of the aspect from the request |
| text | string | Summary text |
| rankScore | float | Only applicable for extractive summary |
| offset | int | Start position of the context in character. Only applicable for document summary. |
| length | int | Length of the context in character. Only applicable for document summary |
| context | string[] | conversationItem id list of the context. Only applicable for conversation summary. |

For extractive summary, the summary context is just the extracted sentence text itself.

## Document Summarization Example

### Request

```json
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
            "kind": "DocumentSummarizationTask",
            "taskName": "document extractive task 1",
            "parameters": {
                "genre": "generic",
                "aspects": ["generic"],
                "abstractiveness": "extractive",
                "sentenceCount": 3,
                "sortBy": "Offset"
            }
        },
        {
            "kind": "DocumentSummarizationTask",
            "taskName": "document abstractive task 2",
            "parameters": {
                "genre": "generic",
                "aspects": ["generic"],
                "abstractiveness": "abstractive",
                "length": "long"
            }
        }
    ]
}
```

### Response

```json
{
    "jobId": "da3a2f68-eb90-4410-b28b-76960d010ec6",
    "lastUpdateDateTime": "2021-08-24T19:15:47Z",
    "createdDateTime": "2021-08-24T19:15:28Z",
    "expirationDateTime": "2021-08-25T19:15:28Z",
    "status": "succeeded",
    "errors": [],
    "displayName": "NA",
    "tasks": {
        "completed": 2,
        "failed": 0,
        "inProgress": 0,
        "total": 2,
        "items": [
            {
                "lastUpdateDateTime": "2021-08-24T19:15:48.0011189Z",
                "taskName": "document extractive task 1",
                "state": "succeeded",
                "results": {
                    "documents": [
                        {
                            "id": "1",
                            "summaries": [
                                {
                                    "text": "At Microsoft, we have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding.",
                                    "rankScore": 1.0,
                                    "offset": 0,
                                    "length": 160
                                },
                                {
                                    "text": "In my role, I enjoy a unique perspective in viewing the relationship among three attributes of human cognition: monolingual text (X), audio or visual sensory signals, (Y) and multilingual (Z).",
                                    "rankScore": 0.9582327572675664,
                                    "offset": 324,
                                    "length": 192
                                },
                                {
                                    "text": "At the intersection of all three, there’s magic—what we call XYZ-code as illustrated in Figure 1—a joint representation to create more powerful AI that can speak, hear, see, and understand humans better.",
                                    "rankScore": 0.9294747193132348,
                                    "offset": 517,
                                    "length": 203
                                }
                            ],
                            "warnings": []
                        }
                    ],
                    "errors": [],
                    "modelVersion": "2021-08-01"
                }
            },
            {
                "lastUpdateDateTime": "2021-08-24T19:15:48.0011189Z",
                "taskName": "document abstractive task 2",
                "state": "succeeded",
                "results": {
                    "documents": [
                        {
                            "id": "1",
                            "summaries": [
                                {
                                    "offset": 0,
                                    "length": 1629,
                                    "text": "Microsoft have been on a quest to advance AI beyond existing techniques, by taking a more holistic, human-centric approach to learning and understanding. The breakthroughs provided strong signals toward ambitious aspiration."
                                }
                            ],
                            "warnings": []
                        }
                    ],
                    "errors": [],
                    "modelVersion": "2021-08-01"
                }
            }
        ]
    }
}
```

## Conversation Summarization Example

### Request

```json
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
                        "startTime": "00:00:22",
                        "participantId": "Agent_1"
                    },
                    {
                        "text": "Yes, I pushed the wifi connection button, and now the power light is slowly blinking.",
                        "id": "4",
                        "role": "Customer",
                        "startTime": "00:00:25",
                        "participantId": "Customer_1"
                    },
                    {
                        "text": "Great. Thank you! Now, please check in your Contoso Coffee app. Does it prompt to ask you to connect with the machine?",
                        "id": "5",
                        "role": "Agent",
                        "startTime": "00:00:29",
                        "participantId": "Agent_1"
                    },
                    {
                        "text": "No. Nothing happened.",
                        "id": "6",
                        "role": "Customer",
                        "startTime": "00:00:30",
                        "participantId": "Customer_1"
                    },
                    {
                        "text": "I’m very sorry to hear that. Let me see if there’s another way to fix the issue. Please hold on for a minute.",
                        "id": "7",
                        "role": "Agent",
                        "startTime": "00:00:35",
                        "participantId": "Agent_1"
                    }
                ]
            }
        ]
    },
    "tasks": [
        {
            "taskName": "Issue and Resolution Task 1",
            "kind": "ConversationalSummarizationTask",
            "parameters": {
                "genre": "callcenter",
                "abstractiveness": "abstractive",
                "aspects": [
                    "issue",
                    "resolution"
                ]
            }
        },
        {
            "taskName": "Chapters and Notes Task 2",
            "kind": "ConversationalSummarizationTask",
            "parameters": {
                "genre": "generic",
                "abstractiveness": "abstractive",
                "aspects": [
                    "title",
                    "generic"
                ]
            }
        }
    ]
}
```

#### Response

```json
{
    "jobId": "738120e1-7987-4d19-af0c-89d277762a2f",
    "lastUpdatedDateTime": "2022-05-31T16:52:59Z",
    "createdDateTime": "2022-05-31T16:52:51Z",
    "expirationDateTime": "2022-06-01T16:52:51Z",
    "status": "succeeded",
    "errors": [],
    "displayName": "Analyze conversations from 123",
    "tasks": {
        "completed": 2,
        "failed": 0,
        "inProgress": 0,
        "total": 2,
        "items": [
            {
                "kind": "conversationalSummarizationResults",
                "taskName": "Issue and Resolution Task 1",
                "lastUpdateDateTime": "2022-05-31T16:52:59.85913Z",
                "status": "succeeded",
                "results": {
                    "conversations": [
                        {
                            "id": "conversation1",
                            "summaries": [
                                {
                                    "context": [
                                        "1",
                                        "2",
                                        "3",
                                        "4",
                                        "5",
                                        "6",
                                        "7"
                                    ],
                                    "aspect": "issue",
                                    "text": "Customer tried to set up wifi connection for Smart Brew 300 machine, but it didn't work"
                                },
                                {
                                    "context": [
                                        "1",
                                        "2",
                                        "3",
                                        "4",
                                        "5",
                                        "6",
                                        "7"
                                    ],
                                    "aspect": "resolution",
                                    "text": "Asked customer to try the following steps | Asked customer for the power light | Checked if the app is prompting to connect to the machine | Transferred the call to a tech support"
                                }
                            ],
                            "warnings": []
                        }
                    ],
                    "errors": [],
                    "modelVersion": "2022-05-15-preview"
                }
            },
            {
                "kind": "conversationalSummarizationResults",
                "taskName": "Chapters and Notes Task 2",
                "lastUpdateDateTime": "2022-05-31T16:52:59.85913Z",
                "status": "succeeded",
                "results": {
                    "conversations": [
                        {
                            "id": "conversation1",
                            "summaries": [
                                {
                                    "context": [
                                        "1",
                                        "2",
                                        "3"
                                    ],
                                    "aspect": "title",
                                    "text": "Machine Connection Prompting"
                                },
                                {
                                    "context": [
                                        "1",
                                        "2",
                                        "3"
                                    ],
                                    "aspect": "generic",
                                    "text": "Customer_1 inqueried the wifi connection issue."
                                },
                                {
                                    "context": [
                                        "4",
                                        "5",
                                        "6",
                                        "7"
                                    ],
                                    "aspect": "title",
                                    "text": "Contoso App"
                                },
                                {
                                    "context": [
                                        "4",
                                        "5",
                                        "6",
                                        "7"
                                    ],
                                    "aspect": "generic",
                                    "text": "Agent_1 asked Customer_1 to check the Contoso app."
                                }
                            ],
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
