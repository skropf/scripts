from hashlib import sha1
from multiprocessing.dummy import Pool

start = 100000000000000
sha1_hash = 'e5b1149132aab56eba55168d0b0c7a095ab066f2'
salt = 'sME9Azj8G28Y'

def crack((thread_number, counter, range_to_calc)):
	start = counter
	not_found = True
	while not_found:
		if start + range_to_calc == counter: break
		r = range(counter + 0, counter + 1000000)

		for i in r:
			hashed = sha1(salt+str(i)).hexdigest()
			if hashed == sha1_hash:
				fh = open('result', 'a')
				fh.write(str(i) + '\n')
				fh.close()
				not_found = False

		if not_found:
			counter += 1000000

	return not_found

pool = Pool(8)
my_array = [('1', start+000000000, 100000000),
						('2', start+100000000, 100000000),
						('3', start+200000000, 100000000),
						('4', start+300000000, 100000000),
						('5', start+400000000, 100000000),
						('6', start+500000000, 100000000),
						('7', start+600000000, 100000000),
						('8', start+700000000, 100000000)]
#pool.map(crack, my_array)