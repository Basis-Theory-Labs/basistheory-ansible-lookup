setup:
	python3 -m venv venv && venv/bin/pip install -r requirements.txt

prep:
	bash ansible_prep.sh

run:
	venv/bin/ansible-playbook -i inventory lookup_test.yml

clean:
	rm -rf venv /tmp/lookup_test.cfg /tmp/my.properties
