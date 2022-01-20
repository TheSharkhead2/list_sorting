function insertionSort(sortList)
    """ 
    Sorts list using a probably not-great implementation of insertion sort

    Parameters
    ----------

    sortList : 1d array
        List to be sorted

    Returns
    -------

    sortList : 1d array 
        Sorted list

    """

    for i in 2:length(sortList) #go through all indices of the list to be sorted (starting with i=2)
        for j in (i-1):-1:1 #loop through all previous indices in reverse order
            if sortList[j+1] < sortList[j] #if the current index is less than the index below (this will adapt as it is shifted down)
                sortList[j+1], sortList[j] = sortList[j], sortList[j+1] #swap adjacent elements 

            else 
                break #if it is greater, have already exhuasted stuff, break loop
            end
        end
    end

    sortList
end

function generate_good_list(n)
    """ 
    Generates the "best" case for insertion sort of a list of length n. This
    will be an already sorted list.

    Parameters
    ----------

    n : Int
        Length of list 

    Returns
    -------

    list : vector
        List of ordered numbers

    """

    Vector(1:n) #generate a vector of ordered numbers up to n
    
end

function generate_bad_list(n)
    """ 
    Generates the "worse" case for insertion sort of a list of length n. This
    will be a list in opposite order

    Parameters
    ----------

    n : Int
        Length of list 

    Returns
    -------

    list : vector
        List of ordered numbers

    """

    reverse(Vector(1:n)) #generate a vector of ordered numbers up to n and reverse it
    
end

for listLength in ARGS[2:length(ARGS)] #interpret all arguments as list lengths to test
    #generate a good and a bad list
    goodList = generate_good_list(parse(Int, listLength))
    badList = generate_bad_list(parse(Int, listLength))

    if ARGS[1] == "good"
        beginTimeGood = time() #get time before starting sorting 
        insertionSort(goodList)
        totalTimeGood = time() - beginTimeGood #get total time good sort took 

        println("For the length: $listLength an ideal list took $totalTimeGood seconds to sort")

    elseif ARGS[1] == "bad"

        beginTimeBad = time() #get time before starting sorting 
        insertionSort(badList)
        totalTimeBad = time() - beginTimeBad #get total time bad sort took 

        println("For the length: $listLength the worst case list took $totalTimeBad seconds to sort")

    end

    
end