function countingSort(sortList)
    """ 
    My own implementation of counting sort. Counting sort, explained briefly,
    sorts a list by counting the number of entries of each integer in the 
    range of the list and then constructs a new list with that number of each
    entry. This new list will be sorted. 

    Parameters
    ----------

    sortList : Vector{Int}
        Unsorted list 

    Returns
    -------

    sortedList : Vector{Int}
        Sorted list

    """

    listRange = maximum(sortList) - minimum(sortList) + 1 #get range of list (need to add 1 to account for the fact that you need to include the boundry max and min values)

    countingList = Vector{Int}(zeros(listRange)) #create list of zeros in order to count up all items in range

    for i in sortList #loop through all entries in list 
        countingList[i] += 1 #count up one for the integer entry of entry in list 
    end 

    sortedList = [] #contruct an empty list to append sorted values to

    for (index, count) in enumerate(countingList) #loop through all entries in the counting list along with the index
        append!(sortedList, fill(index+(1- minimum(sortList)), count)) #append new array consisting of only the index integer value and count of them to the new array (need to add minimum to index value to account for possible shifting of the array is the minimum is not 1)
    end

    sortedList

end

if ARGS[1] == "test"
    listRange = parse(Int, ARGS[2]) #take second argument as range
    listLength = parse(Int, ARGS[3]) #take third argument as list length

    testVector = rand(1:listRange, listLength-2) #create random test vector of specified length minus two 

    #add last to entries to list to ensure the right range. This will be 1 and the max range
    append!(testVector, [1, listRange]) 

    myImpleSort = countingSort(testVector) #run my counting sort algorithm on the vector
    juliaSort = sort(testVector) #run Julia's sorting algorithm 

    if myImpleSort == juliaSort #see if it was the same result 
        println("For lists with a range $range and a length $length, this counting sort algorithm agrees with Julia's")
    else
        println("This is unfortunate")
    end

else #if we don't see test in the first argument, assume we are testing scenarios
    #get list and range in arguments
    listRange = parse(Int, ARGS[1])
    listLength = parse(Int, ARGS[2])

    testVector = rand(1:listRange, listLength-2) #create random test vector of specified length minus two 

    #add last to entries to list to ensure the right range. This will be 1 and the max range
    append!(testVector, [1, listRange]) 

    beginTime = time() #get start time 
    sortedList = countingSort(testVector) #sort list 
    totalTime = time() - beginTime #get total time 

    println("With a range of $listRange and a length of $listLength, it took $totalTime seconds")

end