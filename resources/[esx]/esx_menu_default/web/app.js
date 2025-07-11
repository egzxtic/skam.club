class menu {
	constructor(containerId = 'menus', resourceName = GetParentResourceName()) {
	  this.container = document.getElementById(containerId);
	  this.resourceName = resourceName;
	  this.opened = {};
	  this.focusStack = [];
	  this.positions = {};
  
	  window.addEventListener('message', (event) => this.onData(event.data));
	}
  
	open(namespace, name, data) {
	  if (!this.opened[namespace]) this.opened[namespace] = {};
	  if (this.opened[namespace][name]) this.close(namespace, name);
	  if (!this.positions[namespace]) this.positions[namespace] = {};
  
	  data._namespace = namespace;
	  data._name = name;
	  data.elements = data.elements.map((el, i) => ({
		type: el.type || 'default',
		selected: false,
		...el,
		_namespace: namespace,
		_name: name,
	  }));
  
	  this.opened[namespace][name] = data;
	  this.positions[namespace][name] = 0;
  
	  data.elements.forEach((el, i) => {
		if (el.selected) this.positions[namespace][name] = i;
		else el.selected = false;
	  });
  
	  this.focusStack.push({ namespace, name });
	  this.render();
	  this.scrollToSelected(namespace, name);
	}
  
	close(namespace, name) {
	  if (this.opened[namespace]) delete this.opened[namespace][name];
	  this.focusStack = this.focusStack.filter(
		(f) => f.namespace !== namespace || f.name !== name
	  );
	  this.render();
	}
  
	getFocused() {
	  return this.focusStack.length
		? this.focusStack[this.focusStack.length - 1]
		: undefined;
	}
  
	render() {
	  this.container.innerHTML = '';
	  const focused = this.getFocused();
  
	  for (const [namespace, menus] of Object.entries(this.opened)) {
		for (const [name, data] of Object.entries(menus)) {
		  const menuEl = this.createMenuElement(namespace, name, data);
		  menuEl.style.display =
			focused && focused.namespace === namespace && focused.name === name
			  ? ''
			  : 'none';
		  this.container.appendChild(menuEl);
		}
	  }
	  this.container.style.display = focused ? '' : 'none';
	}
  
	createMenuElement(namespace, name, data) {
	  const div = document.createElement('div');
	  div.id = `menu_${namespace}_${name}`;
	  div.className = `menu${data.align ? ' align-' + data.align : ''}`;
  
	  const wrapper = document.createElement('div');
	  wrapper.className = 'menu-items-wrapper';
  
	  const items = document.createElement('div');
	  items.className = 'menu-items';
  
	  const separator = document.createElement('div');
	  separator.className = 'separator';
	  separator.innerText = 'SKAM';
	  items.appendChild(separator);
  
	  const head = document.createElement('div');
	  head.className = 'head';
	  head.innerHTML = `<span>${data.title || ''}</span>`;
	  items.appendChild(head);
  
	  data.elements.forEach((el, i) => {
		const item = document.createElement('div');
		item.className = `menu-item${i === this.positions[namespace][name] ? ' selected' : ''}`;
		item.innerHTML = el.label || '';
  
		if (el.type === 'slider') {
		  const value = el.options ? el.options[el.value] : el.value;
		  const span = document.createElement('span');
		  span.innerHTML = `&lt; ${value} &gt;`;
		  item.appendChild(document.createTextNode(': '));
		  item.appendChild(span);
  
		  const input = document.createElement('input');
		  input.type = 'text';
		  input.style.display = 'none';
		  item.appendChild(input);
		}
		items.appendChild(item);
	  });
  
	  wrapper.appendChild(items);
	  div.appendChild(wrapper);
	  return div;
	}
  
	scrollToSelected(namespace, name) {
	  const menu = document.getElementById(`menu_${namespace}_${name}`);
	  if (menu) {
		const selected = menu.querySelector('.menu-item.selected');
		if (selected) selected.scrollIntoView({ block: 'nearest' });
	  }
	}
  
	submit(namespace, name, current) {
	  const elements = this.opened[namespace][name].elements.map((el) => ({
		label: el.label,
		value: el.value,
		selected: el.selected,
	  }));
	  $.post(
		`https://${this.resourceName}/menu_submit`,
		JSON.stringify({
		  _namespace: namespace,
		  _name: name,
		  current,
		  elements,
		})
	  );
	}
  
	cancel(namespace, name) {
	  $.post(
		`https://${this.resourceName}/menu_cancel`,
		JSON.stringify({
		  _namespace: namespace,
		  _name: name,
		})
	  );
	}
  
	change(namespace, name, current) {
	  const elements = this.opened[namespace][name].elements.map((el) => ({
		label: el.label,
		value: el.value,
		selected: el.selected,
	  }));
	  $.post(
		`https://${this.resourceName}/menu_change`,
		JSON.stringify({
		  _namespace: namespace,
		  _name: name,
		  current,
		  elements,
		})
	  );
	}
  
	del(namespace, name, current) {
	  $.post(
		`https://${this.resourceName}/menu_delete`,
		JSON.stringify({
		  _namespace: namespace,
		  _name: name,
		  current,
		})
	  );
	}
  
	onData(data) {
	  switch (data.action) {
		case 'openMenu':
		  this.open(data.namespace, data.name, data.data);
		  break;
		case 'closeMenu':
		  this.close(data.namespace, data.name);
		  break;
		case 'focusMenu':
		  break;
		case 'controlPressed':
		  this.handleControl(data.control);
		  break;
		default:
		  break;
	  }
	}
  
	handleControl(control) {
	  const focused = this.getFocused();
	  if (!focused) return;
	  const { namespace, name } = focused;
	  const menu = this.opened[namespace][name];
	  const pos = this.positions[namespace][name];
  
	  if (!menu || !menu.elements.length) return;
  
	  switch (control) {
		case 'ENTER':
		case 'NENTER':
		  this.submit(namespace, name, menu.elements[pos]);
		  break;
		case 'BACKSPACE':
		  this.cancel(namespace, name);
		  break;
		case 'TOP':
		  this.positions[namespace][name] =
			pos > 0 ? pos - 1 : menu.elements.length - 1;
		  this.refreshSelection(menu, namespace, name);
		  break;
		case 'DOWN':
		  this.positions[namespace][name] =
			pos < menu.elements.length - 1 ? pos + 1 : 0;
		  this.refreshSelection(menu, namespace, name);
		  break;
		case 'LEFT':
		  this.handleSlider(namespace, name, -1);
		  break;
		case 'RIGHT':
		  this.handleSlider(namespace, name, 1);
		  break;
		case 'DELETE':
		  const el = menu.elements[pos];
		  if (
			['item_money', 'item_weapon', 'item_account', 'item_standard'].includes(
			  el.type
			)
		  ) {
			this.del(namespace, name, el);
		  } else if (el.type === 'slider') {
			el.value = el.min || 0;
			this.change(namespace, name, el);
			this.render();
		  }
		  break;
		default:
		  break;
	  }
	  this.render();
	  this.scrollToSelected(namespace, name);
	}
  
	refreshSelection(menu, namespace, name) {
	  const pos = this.positions[namespace][name];
	  menu.elements.forEach((el, i) => {
		el.selected = i === pos;
	  });
	  this.change(namespace, name, menu.elements[pos]);
	  this.render();
	  this.scrollToSelected(namespace, name);
	}
  
	handleSlider(namespace, name, direction) {
	  const menu = this.opened[namespace][name];
	  const pos = this.positions[namespace][name];
	  const el = menu.elements[pos];
	  if (el.type !== 'slider') return;
  
	  let restrict = el.restrict || [];
	  let min = el.min || 0;
	  let max =
		typeof el.options !== 'undefined'
		  ? el.options.length - 1
		  : typeof el.max !== 'undefined'
		  ? el.max
		  : null;
  
	  let curr = el.value;
	  let next = curr + direction;
  
	  if (max !== null) {
		if (next > max) next = min;
		if (next < min) next = max;
	  } else {
		next = Math.max(min, next);
	  }
  
	  while (restrict.includes(next) && next !== curr) {
		next += direction;
		if (max !== null && (next > max || next < min)) break;
	  }
  
	  if (!restrict.includes(next)) {
		el.value = next;
		this.change(namespace, name, el);
	  }
	  this.render();
	}
  }
  
  window.onload = function () {
	window.MENU = new menu();
  };