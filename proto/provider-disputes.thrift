namespace java dev.vality.disputes
include "proto/domain.thrift"

typedef string ID

struct Amount {
    1: required domain.Amount value
    2: required i16 exponent
    3: optional string currencyName
}

struct TransactionContext {
    1: required ID transactionId
    2: required domain.ProxyOptions terminalOptions
    3: optional ID invoiceId
    4: optional ID paymentId
}

struct DisputeParams {
    1: required TransactionContext transactionContext
    2: required list<Check> checks
    3: optional Amount amount
    4: optional ID requisiteId
    5: optional string reason
}

struct DisputeContext {
    1: required ID disputeId
    2: required domain.ProxyOptions terminalOptions
}

union Check {
    1: Base64EncodedCheck base64EncodedCheck
}

struct Base64EncodedCheck {
    1: required string base64EncodedSource
    2: optional CheckType checkType
    3: optional string name
}

union CheckType {
    1: CheckSourceTypeJpg jpg
    2: CheckSourceTypePng png
    3: CheckSourceTypePdf pdf
}

struct CheckSourceTypePng {}
struct CheckSourceTypeJpg {}
struct CheckSourceTypePdf {}

union TransactionResult {
    1: TransactionStatusResult statusResult
    2: domain.Failure failure
}

union TransactionStatusResult {
    1: TransactionStatusSuccessResult statusSuccess
    2: TransactionStatusFailResult statusFail
}

struct TransactionStatusFailResult {}
struct TransactionStatusSuccessResult {
    1: optional Amount changedAmount
}

union DisputeResult {
    1: DisputeCreatedResult result
    2: DisputeStatusResult statusResult
    3: domain.Failure failure
}

struct DisputeCreatedResult {
    1: required ID disputeId
}

union DisputeStatusResult {
    1: DisputeStatusPendingResult pendingSuccess
    2: DisputeStatusSuccessResult statusSuccess
    3: DisputeStatusFailResult statusFail
}

struct DisputeStatusPendingResult {}
struct DisputeStatusSuccessResult {}
struct DisputeStatusFailResult {}

struct DisputeCallback {
    1: optional ID transactionId
    2: optional TransactionStatusResult transactionStatusResult
    3: optional ID disputeId
    4: optional DisputeStatusResult disputeStatusResult
}

exception MethodNotSupported {}

service ProviderDisputesService {

    TransactionResult CheckTransactionStatus (1: TransactionContext transactionContext)

    DisputeResult CreateDispute (1: DisputeParams disputeParams)

    DisputeResult CheckDisputeStatus (1: DisputeContext disputeContext) throws (1: MethodNotSupported ex);

}

service ProviderDisputesCallbackService {

    void HandleCallback (1: DisputeCallback disputeCallback)

}
