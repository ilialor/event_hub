import Bool "mo:base/Bool";
import Nat8 "mo:base/Nat8";
import Result "mo:base/Result";
import Text "mo:base/Text";

module {

    public type Subscriber = {
        callback : Principal; // subscriber's canister_id
        filter : EventFilter;
    };

    public type EventField = {
        name : Text;
        value : Blob;
    };

    public type EventFilter = {
        eventType : ?EventName;
        fieldFilters : [EventField];
    };

    public type EventName = {
        #EthEvent;
        #CreateEvent;
        #BurnEvent;
        #CollectionCreatedEvent;
        #CollectionUpdatedEvent;
        #CollectionDeletedEvent;
        #AddToCollectionEvent;
        #RemoveFromCollectionEvent;
        #InstantReputationUpdateEvent;
        #AwaitingReputationUpdateEvent;
        #NewRegistrationEvent;
        #FeedbackSubmissionEvent;
        #Unknown;
    };

    public type Value = {
        #Nat : Nat;
        #Nat8 : Nat8;
        #Int : Int;
        #Text : Text;
        #Blob : Blob;
        #Bool : Bool;
        #Array : [Value];
        #Map : [(Text, Value)];
    };

    public type ReputationChangeRequest = {
        user : Principal;
        reviewer : ?Principal;
        value : ?Nat;
        category : Text;
        timestamp : Nat;
        source : (Text, Nat); // (doctoken_canisterId, documentId)
        comment : ?Text;
        metadata : ?[(Text, Value)];
    };

    public type Event = {
        eventType : EventName;
        topics : [EventField];
        details : ?Text;
        reputation_change : ReputationChangeRequest;
        sender_hash : ?Text;
    };

    public type Category = Text;

    public type Result<S, E> = {
        #Ok : S;
        #Err : E;
    };

    public type EthEvent = actor {
        handleEthEvent : Event -> async Result<Nat, Text>;
        emitEthEvent : Event -> async Result<Nat, Text>;
    };

    public type CreateEvent = actor {
        creation : Event -> async Result<[(Text, Text)], Text>;
    };

    public type BurnEvent = actor {
        burn : Event -> async Result<[(Text, Text)], Text>;
    };

    public type CollectionCreatedEvent = actor {
        collectionCreated : Event -> async Result<[(Text, Text)], Text>;
    };
    public type CollectionUpdatedEvent = actor {
        collectionUpdated : Event -> async Result<[(Text, Text)], Text>;
    };
    public type CollectionDeletedEvent = actor {
        collectionDeleted : Event -> async Result<[(Text, Text)], Text>;
    };
    public type AddToCollectionEvent = actor {
        addToCollection : Event -> async Result<[(Text, Text)], Text>;
    };
    public type RemoveFromCollectionEvent = actor {
        removeFromCollection : Event -> async Result<[(Text, Text)], Text>;
    };
    public type InstantReputationUpdateEvent = actor {
        getCategories : () -> async [(Category, Text)];
        getMintingAccount : () -> async Principal;
        eventHandler : (ReputationChangeRequest) -> async Result<Nat, Text>;
    };
    public type AwaitingReputationUpdateEvent = actor {
        updateReputation : Event -> async Result<[(Text, Text)], Text>;
    };
    public type FeedbackSubmissionEvent = actor {
        feedbackSubmission : Event -> async Result<[(Text, Text)], Text>;
    };

    // public type Events = {
    //     #EthEvent : EthEvent;
    //     #CreateEvent : CreateEvent;
    //     #BurnEvent : BurnEvent;
    //     #CollectionCreatedEvent : CollectionCreatedEvent;
    //     #CollectionUpdatedEvent : CollectionUpdatedEvent;
    //     #CollectionDeletedEvent : CollectionDeletedEvent;
    //     #AddToCollectionEvent : AddToCollectionEvent;
    //     #RemoveFromCollectionEvent : RemoveFromCollectionEvent;
    //     #InstantReputationUpdateEvent : InstantReputationUpdateEvent;
    //     #AwaitingReputationUpdateEvent : AwaitingReputationUpdateEvent;
    //     #FeedbackSubmissionEvent : FeedbackSubmissionEvent;
    // };

    public func textToEventName(text : Text) : EventName {
        switch (text) {
            case ("EthEvent") return #EthEvent;
            case ("CreateEvent") return #CreateEvent;
            case ("BurnEvent") return #BurnEvent;
            case ("CollectionCreatedEvent") return #CollectionCreatedEvent;
            case ("CollectionUpdatedEvent") return #CollectionUpdatedEvent;
            case ("CollectionDeletedEvent") return #CollectionDeletedEvent;
            case ("AddToCollectionEvent") return #AddToCollectionEvent;
            case ("RemoveFromCollectionEvent") return #RemoveFromCollectionEvent;
            case ("InstantReputationUpdateEvent") return #InstantReputationUpdateEvent;
            case ("AwaitingReputationUpdateEvent") return #AwaitingReputationUpdateEvent;
            case ("FeedbackSubmissionEvent") return #FeedbackSubmissionEvent;

            case (_) #Unknown;
        };
    };
    // Answer types
    public type CanisterId = Principal;
    public type Answer = {
        canisterId : CanisterId;
        result : [(Text, Value)];
    };

    public type Success = {
        canisterId : CanisterId;
        result : (Nat, Nat);
    };

    public type Error = {
        canisterId : CanisterId;
        message : Text;
    };

    public type ErrorType = {
        #CommunicationError;
        #ProcessingError;
        #Timeout;
        #CustomError : Text;
    };

    public type SuccessfulSend = {
        canisterId : CanisterId;
    };

    public type SendError = {
        canisterId : CanisterId;
        error : ErrorType;
    };

    public type SubscribersNotifiedResult = {
        successful : [Success];
        errors : [SendError];
    };

    public type AnswersResult = {
        successful : [Answer];
        errors : [SendError];
    };

    public type EmitEventResult = {
        #SubscribersNotified : SubscribersNotifiedResult;
        #Answers : AnswersResult;
    };

};
