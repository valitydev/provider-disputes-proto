namespace java dev.vality.disputes
include "proto/domain.thrift"

typedef string ID
typedef string MIMEType

service ProviderDisputesService {

    DisputeCreatedResult CreateDispute (1: DisputeParams disputeParams)

    DisputeStatusResult CheckDisputeStatus (1: DisputeContext disputeContext)

}

struct DisputeParams {
    1: required TransactionContext transactionContext
    2: required list<Attachment> attachments
    3: optional Amount amount
    4: optional string reason
}

union DisputeCreatedResult {
    1: DisputeCreatedSuccessResult successResult
    2: DisputeCreatedFailResult failResult
}

struct DisputeContext {
    1: required ID disputeId
    2: required domain.ProxyOptions terminalOptions
}

union DisputeStatusResult {
    1: DisputeStatusPendingResult pendingSuccess
    2: DisputeStatusSuccessResult statusSuccess
    3: DisputeStatusFailResult statusFail
}

struct TransactionContext {
    1: required ID providerTrxId
    2: required domain.ProxyOptions terminalOptions
    3: optional ID invoiceId
    4: optional ID paymentId
}

union Attachment {
    1: Base64EncodedAttachment base64EncodedAttachment
}

struct DisputeCreatedSuccessResult {
    1: required ID disputeId
}

struct DisputeCreatedFailResult {
    1: required domain.Failure failure
}

struct DisputeStatusSuccessResult {
    1: optional Amount changedAmount
}

struct DisputeStatusPendingResult {}

struct DisputeStatusFailResult {
    1: required domain.Failure failure
}

struct Amount {
    1: required domain.Amount value
    2: required i16 exponent
    3: optional string currencyName
}

struct Base64EncodedAttachment {
    1: required string base64EncodedSource
    2: optional MIMEType mimeType
    3: optional string name
}
