import "@typespec/versioning";
import "./../../azure_chat_extensions.tsp";
import "./common_options.tsp";

namespace Azure.OpenAI;

using TypeSpec.Versioning;

#suppress "@azure-tools/typespec-azure-core/casing-style" "this represents the case-sensitive wire format"
@added(ServiceApiVersions.v2023_12_01_Preview)
@doc("""
A specific representation of configurable options for SharePoint site when using it as an Azure OpenAI chat
extension.
""")
model SharePointChatExtensionConfiguration
  extends AzureChatExtensionConfiguration {
  @doc("""
  The type label to use when configuring Azure OpenAI chat extensions. This should typically not be changed from its
  default value for Pinecone.
  """)
  type: AzureChatExtensionType.sharePoint;

  @doc("The parameters to use when configuring Azure OpenAI chat extensions.")
  parameters: SharePointChatExtensionParameters;
}

@added(ServiceApiVersions.v2023_12_01_Preview)
@doc("Parameters for configuring Azure OpenAI SharePoint site chat extensions. The supported authentication type is APIKey.")
model SharePointChatExtensionParameters {
  ...OnYourDataCommonChatExtensionConfiguration;

  @doc("The path URL of SharePoint site.")
  sitePath: url;
}
