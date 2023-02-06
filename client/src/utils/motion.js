export const navVariants = {
    hidden: {
      opacity: 0,
			x:-50,
			transition: {
				type: 'string',
				stiffness: 300,
				damping: 140,
			},
    },
		
		show: {
			opacity: 1,
			x:0,
			transition: {
				type: 'spring',
				stiffness: 80,
				delay: 1,
			},
		},
};
