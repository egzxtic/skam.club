
export function cn(...inputs) {
    return twMerge(clsx(...inputs));
  }

export function Logo() {
    return (
        <img security="true" src="https://images-ext-1.discordapp.net/external/Wlf1yRLdZ_R5e0l1O4NNne_oOn0XI2fQPP044KdxvHY/https/r2.fivemanage.com/PsXrY56boeeCIZWpbOkiQ/skam.png?format=webp&quality=lossless&width=1409&height=1079" />
    )
  }
  export const nui = {
  on: (action, callback) => {
    const handler = (event) => {
      if (event.data && event.data.action === action) {
        callback(event.data);
      }
    };
    
    window.addEventListener('message', handler);
    return () => window.removeEventListener('message', handler);
  },
  
  emit: (action, data = {}) => {
    fetch(`https://${window.location.hostname}/${action}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: JSON.stringify(data),
    }).catch(err => console.error('Error sending NUI message', err));
  },
  
  close: () => {
    nui.emit('hideFrame');
  }
};