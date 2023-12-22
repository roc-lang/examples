interface IDCounter
    exposes [
        IDCount,
        initIDCount,
        incID,
        extractState,
    ]
    imports []

ID : U32

IDCount state := (ID, state)

initIDCount : state -> IDCount state
initIDCount = \advanceF ->
    @IDCount (0, advanceF)

incID : IDCount (ID -> state) -> IDCount state
incID = \@IDCount (currID, advanceF) ->
    nextID = currID + 1

    @IDCount (nextID, advanceF nextID)

extractState : IDCount state -> state
extractState = \@IDCount (_, finalState) -> finalState

expect
    { aliceID, bobID, trudyID } =
        initIDCount {
            aliceID: <- incID,
            bobID: <- incID,
            trudyID: <- incID,
        }
        |> extractState

    aliceID == 1 && bobID == 2 && trudyID == 3
